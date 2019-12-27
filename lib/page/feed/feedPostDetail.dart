import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/model/commentModel.dart';
import 'package:flutter_twitter_clone/model/feedModel.dart';
import 'package:flutter_twitter_clone/helper/theme.dart';
import 'package:flutter_twitter_clone/helper/utility.dart';
import 'package:flutter_twitter_clone/page/feed/createFeed.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/state/feedState.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';

class FeedPostDetail extends StatefulWidget {
    FeedPostDetail({Key key,this.postId}) : super(key: key);
   final String postId;

  _FeedPostDetailState createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
 String postId;
  @override
  void initState() { 
    postId = widget.postId;
    var state = Provider.of<FeedState>(context,listen: false);
    state.getpostDetailFromDatabase(postId);
    super.initState();
  }
  Widget _floatingActionButton(){
    return FloatingActionButton(
      onPressed: (){
         Navigator.of(context).pushNamed('/FeedPostReplyPage/'+postId);
       },
      child: Icon(Icons.add),
    );
  }
  
  Widget _commentRow(CommentModel model){
    var state = Provider.of<AuthState>(context,);
    return Container(
      child:  Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
          ),
          child: customListTile(
            context,
            leading: customImage(context, model.user.photoUrl),
            title:  Row(
              children: <Widget>[
                customText(model.user.displayName,style:titleStyle.copyWith(fontSize: 15)),
                SizedBox(width: 5,),
                Expanded(
                  child:Row(children: <Widget>[
                    customText('${model.user.userName}',style:userNameStyle,overflow:TextOverflow.ellipsis),
                    SizedBox(width: 10,),
                    customText('- ${getChatTime(model.createdAt)}',style: TextStyle(fontSize: 12)),
                  ],)
                ),
                SizedBox(width: 10,),
              ],
            ),
            subtitle: customText(model.description),
          )
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          SizedBox(width: 80,),
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/FeedPostReplyPage/'+model.key);
                },
                icon:customIcon(context,size: 18, icon:AppIcon.reply , istwitterIcon: true,),
              ),
            customText(model.commentCount.toString()),
            SizedBox(width: 20,),
           IconButton(
                onPressed:(){addLikeToComment(model.key);},
                icon:customIcon(context,size: 18, icon:model.likeList != null && model.likeList.any((x)=>x.userId == state.userId) ? AppIcon.heartFill : AppIcon.heartEmpty, istwitterIcon: true, iconColor:model.likeList != null && model.likeList.any((x)=>x.userId == state.userId) ? Colors.red : Colors.black38),
              ),
          customText(model.likeCount.toString()),
          ],
        ),
        Divider(height: 0,)
      ],
    )
    );
  }
  Widget _postBody(FeedModel model){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
          ),
          child: ListTile(
            leading: customImage(context, model?.profilePic),
            title: customText(model.name,style:titleStyle),
            subtitle: customText('${model.username}',style: userNameStyle),
            trailing: IconButton(
              onPressed: openbottomSheet,
              icon: customIcon(context,icon:AppIcon.arrowDown,istwitterIcon: true, iconColor: AppColor.lightGrey),
            )
          )
        ),
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 10),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          UrlText(text: model.description,style:TextStyle(fontSize: 17,color: Colors.black, fontWeight: FontWeight.w400),urlStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),),
          SizedBox(height: 10,),
          customInkWell(
            context:context,
            function2: (){
              openImage();
            },
            child:_imageFeed(model.imagePath),
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              customText(getPostTime2(model.createdAt),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black54)),
              SizedBox(width: 10,),
              customText('Twitter for Android',style: TextStyle(color: Theme.of(context).primaryColor))
            ],
          )
        ],)
       ),
       SizedBox(height: 5,),
       Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Divider(),),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10,),
            customText(model.commentCount.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10,),
            customText('comments',style:TextStyle(color: Colors.black54)),
            SizedBox(width: 20,),
            customSwitcherWidget(
              duraton: Duration(milliseconds: 300),
              child: customText(model.likeCount.toString(),style:TextStyle(fontWeight: FontWeight.bold), key: ValueKey(model.likeCount)),
            ),
            SizedBox(width: 10,),
            customText('Likes',style:TextStyle(color: Colors.black54))
          ],
        ),
        SizedBox(height: 10,),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Divider(),),
        _likeCommentShareIcon(model),
        Divider(height: 0,),
        Container(
          height: 6,
          width:fullWidth(context),
          color: TwitterColor.mystic,
        )
      ],
    );
  }
  Widget _imageFeed(String _image){
     return _image == null ? Container() :
      Container(
          alignment: Alignment.centerRight,
          child:Container(
          height: 250,
          width: fullWidth(context) *.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image:DecorationImage(image: customAdvanceNetworkImage(_image),fit:BoxFit.cover)
          ),
        )
      );
   }
  Widget _likeCommentShareIcon(FeedModel model) {
    var state = Provider.of<AuthState>(context,);
    return Container(
      padding: EdgeInsets.only(bottom: 0,top:0),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
         SizedBox(width: 0),
          IconButton(
            onPressed:(){Navigator.of(context).pushNamed('/FeedPostReplyPage/'+model.key);},
            icon:customIcon(context,size: 22, icon:AppIcon.reply , istwitterIcon: true,),
          ),
          SizedBox(width: 10),
           IconButton(
            onPressed:(){addLikeToPost(model.key);},
            icon:customIcon(context,size: 22, icon:model.likeList.any((x)=>x.userId == state.userId) ? AppIcon.heartFill : AppIcon.heartEmpty, istwitterIcon: true, iconColor: model.likeList.any((x)=>x.userId == state.userId) ? Colors.red : AppColor.darkGrey),
          ),SizedBox(width: 10),
          IconButton(
                onPressed:(){share('social.flutter.dev/feed/${model.key}',subject:'${model.name}\'s post');},
                icon:  Icon( Icons.share,color:AppColor.darkGrey),
              ),
              SizedBox(width: 0),
        ],
    )
    );
  }
  void openbottomSheet()async{
       await showModalBottomSheet(
         backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
          return Container(
            height: fullHeight(context) *.4,
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            child: Column(children: <Widget>[
              Container()
            ],),
          );
        }
      );
  }
  void addLikeToPost(String postId){
      var state = Provider.of<FeedState>(context,);
      var authState = Provider.of<AuthState>(context,);
      state.addLikeToPost(postId, authState.userId);
  }
  void addLikeToComment(String commentId){
      var state = Provider.of<FeedState>(context,);
      var authState = Provider.of<AuthState>(context,);
      state.addLikeToComment(postId:state.feedModel.key , commentId:commentId,userId: authState.userId);
  }
  void openImage()async{
    Navigator.pushNamed(context, '/ImageViewPge');
  }
  @override
  Widget build(BuildContext context) {
     var state = Provider.of<FeedState>(context,);
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      backgroundColor: Theme.of(context).backgroundColor,
     body:CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
             title: customTitleText('Thread'),
             iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
             backgroundColor: Theme.of(context).appBarTheme.color,
             bottom: PreferredSize(child: Container(color:  Colors.grey.shade200 , height:1.0 ,), preferredSize: Size.fromHeight(0.0))
            ),
             SliverList(
               delegate: SliverChildListDelegate([ _postBody(state.feedModel),],),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                state.commentlist == null || state.commentlist.length == 0 ? 
                [ Container(child:Center(
                  //  child: Text('No comments'),
                ))]
                :state.commentlist.map((x)=> _commentRow(x)).toList()
              ),)
          ])
    );
  }
}