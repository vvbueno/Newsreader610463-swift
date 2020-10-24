//
//  RegisterView.swift
//  Newsreader610463
//
//  Created by Vicente on 24/10/2020.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isTryingToRegister: Bool = false
    @State var isRequestErrorViewPresent: Bool = false
    @State var requestErrorViewMessage: String? = nil
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        VStack {
            if isTryingToRegister {
                ProgressView("trying_register")
            } else {
                VStack{
                    TextField("enter_username", text: $username)
                        .padding()
                        .border(Color.black.opacity(0.2), width: 1)
                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    SecureField("enter_password", text: $password)
                        .padding()
                        .border(Color.black.opacity(0.2), width: 1)
                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    SecureField("enter_confirm_password", text: $confirmPassword)
                        .padding()
                        .border(Color.black.opacity(0.2), width: 1)
                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                }.padding(.bottom, 20)

                Button(action:{
                    
                    isTryingToRegister = true
                    
                    if(username.isEmpty || password.isEmpty || confirmPassword.isEmpty){
                        isRequestErrorViewPresent = true
                        requestErrorViewMessage = "fields_required"
                        isTryingToRegister = false
                        return
                    }
                    
                    if(password != confirmPassword){
                        isRequestErrorViewPresent = true
                        requestErrorViewMessage = "password_do_not_match"
                        isTryingToRegister = false
                        return
                    }
                    
                    NewsReaderAPI.shared.register(username: username, password: password) {(result) in
                        switch result {
                        case .success(let response):
                            
                            if(!response.success){
                                isRequestErrorViewPresent = true
                                requestErrorViewMessage = response.message
                            }else{
                                NewsReaderAPI.shared.login(username: username, password: password) {(result) in
                                    switch result {
                                    case .success(let response):
                                        NewsReaderAPI.shared.accessToken = response.authToken
                                        userSettings.username = username
                                    case .failure(_):
                                        print("An error occurred while logging in after registering")
                                        break
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
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
                        isTryingToRegister = false
                    }
                }, label: {
                    SwiftUI.Text("register")
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
        .navigationTitle("register")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
