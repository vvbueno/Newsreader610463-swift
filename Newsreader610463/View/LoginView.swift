//
//  LoginView.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var username: String = ""
    @State var password: String = ""
    @State var isTryingToLogin: Bool = false
    @State var isRequestErrorViewPresent: Bool = false
    @State var requestErrorViewMessage: String? = nil
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        VStack {
            if isTryingToLogin {
                ProgressView("trying_login")
            } else {
                TextField("enter_username", text: $username)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                SecureField("enter_password", text: $password)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                Button(action:{
                    isTryingToLogin = true
                    
                    if(username.isEmpty || password.isEmpty){
                        isRequestErrorViewPresent = true
                        requestErrorViewMessage = "fields_required"
                        isTryingToLogin = false
                        return
                    }
                    
                    NewsReaderAPI.shared.login(username: username, password: password) {(result) in
                        switch result {
                        case .success(let response):
                            NewsReaderAPI.shared.accessToken = response.authToken
                            userSettings.username = username
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            self.isRequestErrorViewPresent = true
                            switch error {
                            case .urlError(let urlError):
                                switch URLError.Code(rawValue: urlError.errorCode) {
                                case .notConnectedToInternet:
                                    self.requestErrorViewMessage = "not_connected_internet"
                                case .networkConnectionLost:
                                    self.requestErrorViewMessage = "connection_lost"
                                default:
                                    self.requestErrorViewMessage = "login_fail"
                                    break
                                }
                            default:
                                self.requestErrorViewMessage = "login_fail"
                            }
                        }
                        self.isTryingToLogin = false
                    }
                }, label: {
                    SwiftUI.Text("log_in")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.white)
                })
                .background(Color.blue)
                .cornerRadius(8.0)
            }
            
        }
        .padding()
        .alert(isPresented: $isRequestErrorViewPresent){
            Alert(title: Text("failure"), message: Text(requestErrorViewMessage ?? "login_fail"), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("log_in")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
