
import SwiftUI
struct PostCard: View {
    @ObservedObject var postCardService = PostCardService()
    
    @State private var animate = false
    private let duration: Double = 0.2
    
    private var animationScale: CGFloat{
        postCardService.isLiked ? 0.5 : 2.0
    }
    private var dislikeanimationScale: CGFloat{
        postCardService.isDisliked ? 0.5 : 2.0
    }
     
    init(post: PostModel){
        self.postCardService.post = post
        self.postCardService.hasLikedPost()
        self.postCardService.hasDislikedPost()
    }
    
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(spacing: 15){
                Button(action:{
                    self.animate = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                        self.animate = false
                        
                        if(self.postCardService.isLiked){
                            self.postCardService.unlike()
                        }else{
                            self.postCardService.like()
                        }
                    })
                })  {
                    Image(systemName: (self.postCardService.isLiked) ? "heart.fill": "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor((self.postCardService.isLiked) ? .color0 : .white )
                }.padding().scaleEffect(animate ? animationScale : 1)
                    .animation(.easeIn(duration: duration))
                
                
                /*  Button (action:{
                 self.animate = true
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                 self.animate = false
                 
                 if(self.postCardService.isDisliked){
                 self.postCardService.undislike()
                 }else{
                 self.postCardService.dislike()
                 }
                 })
                 
                 }){
                 Image(systemName: (self.postCardService.isDisliked) ? "heart.slash.fill": "heart.slash")
                 .resizable()
                 .frame(width: 25, height: 25, alignment: .center)
                 .foregroundColor((self.postCardService.isDisliked) ? .color0 : .white )
                 }.padding().scaleEffect(animate ? dislikeanimationScale : 1)
                 .animation(.easeIn(duration: duration))
                 */
                NavigationLink(destination: CommentView(post: self.postCardService.post)){
                    Image(systemName: "bubble.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                    Spacer()
                }.padding(.leading, 16)
            }
            if(self.postCardService.post.likeCount > 0 && self.postCardService.post.likeCount == 1){
                Text("\(self.postCardService.post.likeCount) like")
                
            } else if (self.postCardService.post.likeCount > 0 && self.postCardService.post.likeCount > 1){
                Text("\(self.postCardService.post.likeCount) likes")
            }
            
            if(self.postCardService.post.dislikeCount > 0 && self.postCardService.post.dislikeCount == 1){
                Text("\(self.postCardService.post.dislikeCount) dislike")
                
            } else if (self.postCardService.post.dislikeCount > 0 && self.postCardService.post.dislikeCount > 1){
                Text("\(self.postCardService.post.dislikeCount) dislikes")
            }
            NavigationLink(destination: CommentView(post: self.postCardService.post)){
                
                Text("View Comments").font(.caption).padding(.leading, 5)
            }
            }
        }
        

    }

