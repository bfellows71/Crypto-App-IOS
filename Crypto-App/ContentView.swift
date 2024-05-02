
/*
 
 
 To-do:
 
    [x] Find a good api to use and import a crypto's name, price and symbol
    [-] Create a way to set a notification that sends to the user's phone if a price exceeds or drops below their desired price
    [x] Click on a certain crypto then create a navigation link to see more details about it
    [-] UI Overhaul to make it much better looking
    [x] Move the target price to the navigation link page
    [-] Trend lines implemented but needs improvement
            (https://developer.apple.com/documentation/charts/linemark)
        [Currently I can only get a horizontal line to where the current price is, but
            what the goal is to have a linear progression from the $0 price mark up to the current price.
            I explored some solutions like GeometryReader and Paths but it didn't want to play nice.]
 
 
    Bug: 'unable to decode json', landing in the try, catch block and it only does it occasionally. works 90% of the time
    

 */

import SwiftUI
import Charts

struct ContentView: View {
    
    // set state variable of the cryptodata located in apicaller
    @State private var cryptoData: [CryptoData] = []
    
    var body: some View {
            NavigationView {
                VStack {
                    
                    List(cryptoData, id: \.id) { crypto in
                        NavigationLink(destination: CryptoDetails(crypto: crypto, cryptoData: self.cryptoData)) {
                            
                            HStack {
                                
                                // text for the crypto name
                                Text(crypto.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    
                                
                                // text for the crypto price and will change prices depending on the 24h percentage
                                Text("\(String(format: "%.2f", crypto.price_change_percentage_24h))%")
                                    .font(.subheadline)
                                    .foregroundColor(crypto.price_change_percentage_24h >= 0 ? .green : .red)
                                
                                
                                Spacer()
                                
                                // this section will use the vstack to check the currentprice of the crypto and the symbol
                                VStack(alignment: .trailing) {
                                    Text("Price: $\(String(format: "%.2f", crypto.currentPrice))")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                    Text("Symbol: \(crypto.symbol)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    // trigger action before it appears
                    .onAppear {
                        self.fetchCryptoData()
                    }
                }
                .navigationTitle("My Crypto Monitor")
                .navigationBarTitleDisplayMode(.inline)
            }
        }

    
    
    

    /*
     This section is dedicated to the functions and the framework of using a jsondecoder and setting it
     to public variables
     */
    
    // Function to fetch crypto data
    func fetchCryptoData() {
        
        
        // add or remove currencies, you just edit the end of the line (for future ref)
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin,ethereum,sui,xrp,litecoin,solana,dogecoin,gala,tether,bnb,usdc,toncoin,cardano,tron,avalanche,uniswap"
        
        // create a url from the string
        guard let url = URL(string: urlString) 
        else {
            print("URL Is Invalid or does not exist")
            return
        }
        
        // task will asynchronously fetch the data from a url. it creates a task based on the contents of the url, then sets up a handler on completion
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil
            else {
                print("unable to fetch data from url: \(error?.localizedDescription ?? "or unknown error catch")")
                return
            }
            
            // Using the json decoder here that adopts type codable so its decodable from a url
            do {
                
                // CryptoData is located in the ApiCaller swift file
                let decodedData = try JSONDecoder().decode([CryptoData].self, from: data)
                
                // the Dispatchqueue will execute the tasks concurrently on the main thread (faster)
                DispatchQueue.main.async {
                    // store decoded data into cryptoData
                    self.cryptoData = decodedData
                }
            }
            catch {
                print("unable to decode json! \(error.localizedDescription)")
            }
        }
        
        // when completed, resume the task on the main thread.
        task.resume()
    }
}


















// content view
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/*
 This struct handles the CryptoDetails view which is the navigation view
 */

struct CryptoDetails: View {
    let crypto: CryptoData
    let cryptoData: [CryptoData]
    // background gradient colors
    let backgroundColors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink]
    
    var body: some View {
        
        // set the background to the z stack and randomize the background colors
        ZStack {
            let randomIndex = Int.random(in: 0..<backgroundColors.count)
            
            // linear gradient that controls the backgroundColors and you can also control the opacity here, which default is 0.5
            LinearGradient(
                gradient: Gradient(colors: [backgroundColors[randomIndex].opacity(0.2), backgroundColors[randomIndex].opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .zIndex(-1)
            
            
            VStack {
                // url fetcher for the crypto.image
                if let url = URL(string: crypto.image) {
                    AsyncImageView(url:url)
                        .aspectRatio(contentMode: .fit)
                }
                else {
                    Text("image does not work. check api")
                }
                
                // body content
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Price: $\(String(format: "%.2f", crypto.currentPrice))")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                        Text("Low of 24h: $\(String(format: "%.2f", crypto.low_24h))")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                        Text("High of 24h: $\(String(format: "%.2f", crypto.high_24h))")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                        Text("Price change percentage over 24h: \(String(format: "%.2f", crypto.price_change_percentage_24h))%")
                            .font(.subheadline)
                            .foregroundColor(crypto.price_change_percentage_24h >= 0 ? .green : .red)
                            .padding()
                    }
                    
                    /*
                     Chart for the cryptoData but it currently does not work, but can serve
                     as a good placeholder for now.
                     */
                    Chart {
                        ForEach(cryptoData, id: \.id) { crypto in
                            LineMark(
                                x: .value("Time", crypto.currentPrice),
                                y: .value("Price", crypto.currentPrice),
                                series: .value("Crypto", crypto.name)
                            )
                            .foregroundStyle(.blue)
                        }
                        .foregroundStyle(.red)
                    }
                    .padding()
                }
                
                
                
                
                /*
                 Placeholder button for the notifications
                 */
                Button(action: {
                    // call function to send notification()
                }) {
                    Text("Set Target Price")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                
            }
            .navigationTitle(crypto.name)
        }
        
    }
    
    
    
    
    // displays the image fetched from the url and puts a placeholder in the spot where the image 'should' be
    struct AsyncImageView: View {
        
        // Wrapper to change the properties of an object
        @ObservedObject private var imageLoader: ImageLoader
        
        // placeholder image to contain the image's dimensions
        private let placeholder: Image
        
        // initialize the url and the placeholder and turn the placeholder into the url, which is the crypto.image
        init(url: URL, placeholder: Image = Image(systemName: "photo")) {
            
            imageLoader = ImageLoader(url: url)
            
            self.placeholder = placeholder
        }
        
        // this is where the image gets placed onto the screen. you can also adjust the frame size
        var body: some View {
            if let uiImage = imageLoader.image {
                Image(uiImage: uiImage)
                    .resizable()
                
                
                    .frame(width: 100, height: 100)
            } else {
                // if it doesnt work, keep the placeholder
                placeholder
            }
        }
    }
    
    
    
    // async fetches image from the url and updates the image property
    // only works with an internet connection
    class ImageLoader: ObservableObject {
        
        // observable image object and reinvoke the body if needed
        @Published var image: UIImage?
        
        init(url: URL) {
            URLSession.shared.dataTask(with: url) {
                data, _, error in
                guard let data = data, error == nil
                else {
                    return
                }
                
                
                // call it on the main thread
                DispatchQueue.main.async {
                    // store the image using the data
                    self.image = UIImage(data: data)
                }
            }
            // resume the thread (which is why it loads faster. particiularly if you had a lot of images, which my app 'can' have
            .resume()
        }
    }
}




