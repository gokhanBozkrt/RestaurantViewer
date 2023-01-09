//
//  LoginView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 5.01.2023.
//
import Firebase
import SwiftUI


struct LoginView: View {
    enum Field {
        case email,password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var buttonDisabled = true
    @State private var  showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var focusField: Field?
    
    @State private var presentSheet = false
    
    var body: some View {
        VStack  {
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5),lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                Button {
                    login()
                } label: {
                    Text("Login")
                }
                .padding(.leading)
            }
            .disabled(buttonDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("SnackColor"))
            .font(.title2)
            .padding(.top)
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK",role: .cancel) {}
        }
        .onAppear {
            // if logged in when app runs, navigate to the new screen & skip login
            if Auth.auth().currentUser != nil {
                print("😎Login Succses")
               presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ListView()
        }

    }
    
    func enableButtons() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count > 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 Sign Up Error Occured: \(error.localizedDescription)")
                alertMessage = "😡 Sign Up Error Occured: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Registration Succses")
               presentSheet = true
            }
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡Error Occured: \(error.localizedDescription)")
                alertMessage = "😡Error Occured: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Login Succses")
                presentSheet = true
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



