import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct EditProfile: View {
    @EnvironmentObject var session: SessionStore
    @State private var username: String = ""
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error: String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String = "Well Shoot..."
    @State private var bio: String = ""
    
    init (session: User?){
        _bio = State(initialValue: session?.bio ?? "")
        _username = State(initialValue: session?.bio ?? "")
    }
    
    func loadImage() {
        guard let inputImage = pickedImage else{
            return
        }
        profileImage = inputImage
    }
    func errorCheck()-> String?{
        if username.trimmingCharacters(in: .whitespaces).isEmpty ||
            bio.trimmingCharacters(in: .whitespaces).isEmpty ||
            imageData.isEmpty{
            
            return "Well pardner seems like you ain' fill everything out"
        }
        return nil
        
        
    }
    func clear(){
        self.username = ""
        self.bio = ""
        self.imageData = Data()
        self.profileImage = Image(systemName: "person.circle.fill")
    }
    
    func edit() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            return
        }
        guard let userId = Auth.auth().currentUser?.uid
        else{
            return
        }
        let storageProfileUserId = StorageService.storageProfileId(userId: userId)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        StorageService.editProfile(userId: userId, username: username, bio: bio, imageData: imageData, metaData: metadata, storageProfileImageRef: storageProfileUserId, onError: {
            (errorMessage) in
            self.error = errorMessage
            self.showingAlert = true
            return
        })
        self.clear()
        
    }
    
    
    
    
    
    
    
    
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                VStack{
                    Group{
                        if profileImage != nil {
                            profileImage!.resizable()
                                .clipShape(Circle())
                                .frame(width:200,
                                       height: 200).padding(.top, 20).onTapGesture {
                                    self.showingActionSheet = true
                                }
                            
                        } else{
                            WebImage(url: URL(string: session.session!.profileImageUrl))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width:200,
                                       height: 200).padding(.top, 20)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                            
                        }
                    }

                }
                FormField(value: $username, icon: "person.fill", placeholder: "Username")
                FormField(value: $bio, icon: "book.fill", placeholder: "Username")
                
                Button(action: edit){
                    
                    Text("Edit").font(.title).modifier(ButtonModifiers())
                    
                }.padding()
                .alert(isPresented:$showingAlert) {
                    Alert(title: Text(alertTitle),message : Text(error), dismissButton: .default(Text("Alrighty")))
                }
                
                Text("These here changes will happen when you log back in")


            }
            
        }.navigationTitle(session.session!.username)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(pickedImage: self.$pickedImage, showImagePicker: self.$showingImagePicker, imageData: self.$imageData)
            }.actionSheet(isPresented: $showingActionSheet){
                ActionSheet (title: Text(""), buttons: [.default(Text("Pick Yer Picture Partner")){
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                                                        .default(Text("Take Yer Photo")){
                                                            self.sourceType = .camera
                                                            self.showingImagePicker = true
                                                        }, .cancel()
                                                       ])
            }
    }
}
