import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/GroupsPostsTasks.dart';
import 'package:untitled4/createNewGroup.dart';
import 'package:untitled4/groupPosts.dart';
import 'package:untitled4/groupHomePage.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class GroupScreen extends StatefulWidget {
  late String CID;
  late String cname;
  late String cimg="";
  GroupScreen(String companyid,String cname,String cimg){
    this.CID=companyid;
    this.cname=cname;
    this.cimg=cimg;
  }
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

List<Map<String,dynamic>> groupposts=[];
List<Map<String,dynamic>> groups=[];
List<int> members=[];
final networkHandlerC = NetworkHandlerC();
final networkHandler = NetworkHandlerS();
bool isDataReady=false;
bool search=false;
bool lockednow=false;
TextEditingController _group = TextEditingController();
void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
}

Future<void> fetchData() async {
  try {

    groups = await networkHandlerC.getGroups(widget.CID!);
    for (var map in groups) {
      map.forEach((key, value) {
        print('$key: $value');
        if(key=="membersStudent"){
          members.add(value.length);
          print(members);
        }
      });
    }
    groupposts= await networkHandlerC.getGroupspostsid(widget.CID);
    for (var map in groupposts) {
      map.forEach((key, value) {
        print('$key: $value');
      });
    }

    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isDataReady 
      ? Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffffc300),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => createNewGroup(widget.CID,widget.cname,widget.cimg)));
            // print("yes");
          },
          child: Icon(
            Icons.add,
            color: Color(0xff003566),
          ),
        ),
        body: CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 80.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background:Container(
                width: 411,
                height: 70,
                // color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your Groups ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff003566),
                          fontSize: 16),
                    ),
                    Container(
                      width: 280,
                      child: TextField(
                        controller: _group,
                        enabled: true,
                        maxLines: 1,
                        minLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Search",
                            contentPadding: EdgeInsets.all(2),
                            prefixIcon: Icon(Icons.search),
                            iconColor: Color(0xff003566),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: const Color(0xff003566),
                                    width: 10)),
                                    ),
                        onChanged: (value) {
                          if(_group.text.isEmpty){
                          setState(() {
                            _group.text=value;
                            search=false;
                          });}
                          else{
                          setState(() {
                            _group.text=value;
                            search=true;
                          });}
                          
                        },
                      ),
                    )
                  ],
                ),
              ),
                ),),
                SliverToBoxAdapter(
      child: Container(
        height: 215, // Set the height for horizontal scrolling
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: <Widget>[
            SliverList(
                delegate: search 
                ? SliverChildBuilderDelegate(
                  (context, index) { 
                    print(groups[index]['membersStudent'].length);
                    print(members[index]);
                    if(groups[index]['groupname']==_group.text){
                    return Groupss(groups[index]['_id'],groups[index]['cid'],groups[index]['cname'],groups[index]			['cimg'],groups[index]['groupname'], members[index].toString(),groups[index]['groupImg'],groups[index]['islocked'],groups[index]['membersStudentId'],context);
                    }
                  },
                   childCount: groups.length,
                   )
                  : SliverChildBuilderDelegate(
                  (context, index) { 
                    print(groups[index]['membersStudent'].length);
                    print(members[index]);
                   return Groupss(groups[index]['_id'],groups[index]['cid'],groups[index]['cname'],groups[index]			['cimg'],groups[index]['groupname'], members[index].toString(),groups[index]['groupImg'],groups[index]['islocked'],groups[index]['membersStudentId'],context);

                  },
                   childCount: groups.length,
                   ),
            ),//slist
          ],//silvers
        ),//custom
      ),//container
    ),             

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                         return GPosts(widget.cname,widget.cimg,groupposts[index]['postDate'],groupposts[index]['postImg'],groupposts[index]['content']);
                    },
                    childCount: groupposts.length,
                  ),
                ),
            ]),
 )
     :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
  Widget Groupss(String _id,String cid,String cname,String cimg,String name,String memebers,String gimg,bool islocked,membersid, context) {
  return MaterialButton(
    onPressed: () {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyGroupHomePage(_id,cid,cname,cimg,name)));
    },
    child: Container(
      //  color: Colors.blue.shade300,
      margin: EdgeInsets.only(top: 10,bottom: 5),
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5)],
        border: Border.all(width: 1, color: Colors.grey.shade500),
      ),
      height: 220,
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Stack(children: [
                Container(
                width: 400.0,
                height: 120.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:  Image.network("http://localhost:5000/"+gimg,
                  fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                onPressed: () {
                  print(!islocked);
                   setState(() {
                    
                     networkHandlerC.updateislocked(_id,!islocked);
                     if(islocked==false){
                      lockednow=true;
                      networkHandlerC.updateEndDate(_id);
                      for(int i=0;i<membersid.length;i++){
                      networkHandler.updategroupidstud(membersid[i], "", true);
                      networkHandler.updatepostidstud(membersid[i], "", false);
                      }

                     }
                    Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => GroupScreen(widget.CID,widget.cname,widget.cimg)));
                     islocked=!islocked;
                  });
                  
                },
               
                icon: islocked 
                ? Icon(Icons.lock_outline,color: Colors.red,)
                : Icon(Icons.lock_open,color: Colors.green,),
              )
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                onPressed: () {
                  print(!islocked);
                  if(islocked){
                    setState(() {
                      networkHandlerC.deleteGroup(_id);
                    });
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => GroupScreen(widget.CID,widget.cname,widget.cimg)));
                  }                  
                },
               
                icon: islocked 
                ? Icon(Icons.delete_outline_outlined,color:  Color.fromARGB(255, 66, 68, 204),)
                : Icon(Icons.delete_forever_rounded,color:  Color.fromARGB(255, 158, 149, 148),),
              )
              ),             
              ],),

              Container(
                width: 190,
                height: 50,
                margin: EdgeInsets.only(top: 15),

                // color: Colors.purple.shade100,
                child: Column(
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        memebers,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    ),
  );
}

}

Widget GroupPosts(ProName, proPic, requistColor, dateAndLocation, requist,
    seats, lockDate, imagePosts, contentPost) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    child: Row(
      children: <Widget>[
        Container(
          width: 411.0,
          //   height: 660.0,
          // color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 411.0,
                height: 50.0,
                // color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    border: Border.all(
                                        //    color: Color(0xff003566),
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade400),
                                    image: DecorationImage(
                                        image: AssetImage(proPic),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 290.0,
                              height: 20.0,
                              // color: Colors.pink,
                              child: Text(
                                ProName,
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              width: 290.0,
                              height: 30.0,
                              // color: Colors.purple,
                              child: Text(
                                dateAndLocation,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blueGrey[500]),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 61.0,
                          height: 50.0,
                          // color: Colors.brown,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 411.0,
                // height: 480.0,
                //  color: Colors.amber,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Container(
                            //   height: 80.0,
                            width: 411.0,
                            padding: EdgeInsets.all(20),
                            //  color: Colors.blue,
                            child: ReadMoreText(
                              contentPost!,
                              trimLines: 3,
                              style: TextStyle(fontSize: 15),
                              trimCollapsedText: '... Read More',
                              trimExpandedText: '... Read Less',
                              trimMode: TrimMode.Line,
                              textAlign: TextAlign.justify,
                              lessStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              moreStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )

                        // color: Colors.blue,

                        ),
                    Container(
                      width: 411.0,
                      height: 380.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                  ],
                ),
              ) ,
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.grey[320],
                  thickness: 5.0,
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
Widget GPosts(String ProName,String proPic,String dateAndLocation,String imagePosts,String contentPost) {
  return Padding(
    padding: const EdgeInsets.only(left:3,top: 10.0, bottom: 5.0,right: 3),
    child: Row(
      children: <Widget>[
         Divider(
                  thickness: 5,
          ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 405.0,
          //   height: 660.0,
          // color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 411.0,
                height: 50.0,
                // color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    border: Border.all(
                                        //    color: Color(0xff003566),
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade400),
                                    image: DecorationImage(
                                        image: NetworkImage("http://localhost:5000/"+ proPic),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 290.0,
                              height: 20.0,
                              // color: Colors.pink,
                              child: Text(
                                ProName,
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              width: 290.0,
                              height: 30.0,
                              // color: Colors.purple,
                              child: Text(
                                dateAndLocation,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blueGrey[500]),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 30.0,
                          height: 50.0,
                          // color: Colors.brown,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 411.0,
                // height: 480.0,
                //  color: Colors.amber,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Container(
                            //   height: 80.0,
                            width: 411.0,
                            padding: EdgeInsets.all(20),
                            //  color: Colors.blue,
                            child: ReadMoreText(
                              contentPost!,
                              trimLines: 3,
                              style: TextStyle(fontSize: 15),
                              trimCollapsedText: '... Read More',
                              trimExpandedText: '... Read Less',
                              trimMode: TrimMode.Line,
                              textAlign: TextAlign.justify,
                              lessStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              moreStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )

                        // color: Colors.blue,

                        ),
                    Container(
                      width: 411.0,
                      height: 380.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage("http://localhost:5000/"+ imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                  ],
                ),
              ),
             /* Container(
                width: 411.0,
                height: 30.0,
                // color: Colors.green,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 80,
                            height: 30,
                            //color: Colors.blue,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Color(0xff003566),
                                  size: 17,
                                ),
                                Text(
                                  requist,
                                  style: TextStyle(color: Color(0xff003566)),
                                )
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ),*/
              Container(child: Divider()),
            /*  Container(
                width: 411.0,
                height: 30.0,
                //  color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      /* width: 137,
                      height: 30.0,*/
                      // color: Colors.yellow,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 25,
                            icon: Icon(Icons.check),
                            color: requistColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  color: requistColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
            Container(
                      /*  width: 137,
                      height: 30.0,*/
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.person_add_alt),
                            color: Color(0xff003566),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              seats,
                              style: TextStyle(
                                  color: Color(0xff003566),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                   Container(
                      /*   width: 137,
                      height: 30.0,*/
                      //color: Colors.yellow,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.lock_clock_outlined),
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              lockDate,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            */
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.grey[320],
                  thickness: 5.0,
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
