import 'package:flutter/material.dart';

import '../styles/styles.dart';
import 'drawer_page.dart';
import 'home_page.dart';


class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => FriendsStatefulWidgetState();
}

class FriendsStatefulWidgetState extends State<FriendsPage> {
  int _selectedFriendsIndex = 0;
  String searchString = "";
  Future<List<Show>>? friendList;
  Future<List<Show>>? newPeopleList;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetFriendsOptions = <Widget>[
    Text(
      'FRIENDS',
      style: TextStyle(color:  MyColors.primaryDarkest, fontSize: 25.0, fontWeight: FontWeight.w900),
    ),
    Text(
      'NEW PEOPLE',
      style: TextStyle(color:  MyColors.primaryDarkest, fontSize: 25.0, fontWeight: FontWeight.w900),
    ),
  ];

  int getSelectedFriendsIndex() {
    return _selectedFriendsIndex;
  }

  void _onFriendsItemTapped(int index) {
    setState(() {
      _selectedFriendsIndex = index;
    });
    print(_selectedFriendsIndex);
  }

  @override
  void initState() {
    super.initState();
    friendList = fetchFriends();
    newPeopleList = fetchNewPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
          Builder(
            builder: (context) =>
                Center(
                  child: RaisedButton(
                    color:  MyColors.taintedWhite.withOpacity(0),
                    elevation: 0,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    child: Icon(
                      Icons.widgets,
                      size: 30.0,
                      color:  MyColors.primaryDarkest,
                    )
                  ),
                ),
          ),

        backgroundColor:  MyColors.taintedWhite.withOpacity(0), // Colors.transparent,

        title: Center(
          child: _widgetFriendsOptions.elementAt(_selectedFriendsIndex),
        ),

        actions: [
          Icon(Icons.widgets, color:  MyColors.taintedWhite, size: 50.0,),
        ],

        elevation: 0,
      ),

      drawer: MainDrawer(pageId: 2),

      body:
      ////////////////////////////////////////////SEARCH BAR AND CONTENTS////////////////////////////////////////////
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getSelectedFriendsIndex() == 0) ...[
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                  builder: (context, AsyncSnapshot<List<Show>> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: ListView.separated(
                          padding: EdgeInsets.all(8),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return snapshot.data![index].title
                                .toLowerCase()
                                .contains(searchString)
                                ? ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${snapshot.data?[index].imageUrl}'),
                              ),
                              title: Text('${snapshot.data?[index].title}'),
                              subtitle: Text(
                                  '#${snapshot.data?[index].malId}'),
                            )

                                : FloatingActionButton(onPressed: () => Scaffold.of(context).openDrawer(),);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return snapshot.data![index].title
                                .toLowerCase()
                                .contains(searchString)
                                ? Divider()
                                : Container();
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong :('));
                    }
                    return CircularProgressIndicator();
                  },
                  future: friendList,
                ),
            ),
          ] else if(getSelectedFriendsIndex() == 1)...[
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                builder: (context, AsyncSnapshot<List<Show>> snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: ListView.separated(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data![index].title
                              .toLowerCase()
                              .contains(searchString)
                              ? ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  '${snapshot.data?[index].imageUrl}'),
                            ),
                            title: Text('${snapshot.data?[index].title}'),
                            subtitle: Text(
                                '#${snapshot.data?[index].malId}'),
                          )

                              : FloatingActionButton(onPressed: () => Scaffold.of(context).openDrawer(),);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return snapshot.data![index].title
                              .toLowerCase()
                              .contains(searchString)
                              ? Divider()
                              : Container();
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong :('));
                  }
                  return CircularProgressIndicator();
                },
                future: newPeopleList,
              ),
            ),
          ]
        ],
      ),
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


      bottomNavigationBar: Container (
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10,),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                MyColors.primaryDarker,
                MyColors.primaryNormal,
              ],
            ),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.group
                    ),
                    label: 'FRIENDS'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.group_add),
                    label: 'NEW PEOPLE'
                ),
              ],
              backgroundColor: MyColors.primaryNormal.withOpacity(0),
              currentIndex: _selectedFriendsIndex,
              selectedItemColor: Color(0xffffffff), // 0xffEEF0F0
              unselectedItemColor: Color(0xffC2C6D5),
              onTap: _onFriendsItemTapped,
              elevation: 0,
            ),
          )
      ),
    );
  }
}

class Show {
  final int malId;
  final String title;
  final String imageUrl;

  Show({
    required this.malId,
    required this.title,
    required this.imageUrl,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
    );
  }
}

Future<List<Show>> fetchFriends() async {
  return [Show(malId: 1, title: "hello1", imageUrl: ''), Show(malId: 2, title: "hello2", imageUrl: '')];
}

Future<List<Show>> fetchNewPeople() async {
  return [Show(malId: 3, title: "hello3", imageUrl: ''), Show(malId: 4, title: "hello4", imageUrl: '')];
}