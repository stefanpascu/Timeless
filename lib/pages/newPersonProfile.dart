import 'package:flutter/material.dart';

import '../styles/styles.dart';
import 'friends_page.dart';
import 'home_page.dart';


class NewPersonProfile extends StatefulWidget {
  const NewPersonProfile({Key? key}) : super(key: key);

  @override
  State<NewPersonProfile> createState() => NewPersonProfileStatefulWidgetState();
}

class NewPersonProfileStatefulWidgetState extends State<NewPersonProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        Builder(
          builder: (context) =>
              Center(
                child: RaisedButton(
                    color: MyColors.taintedWhite.withOpacity(0),
                    elevation: 0,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    child: const Icon(
                      Icons.widgets,
                      size: 30.0,
                      color:  MyColors.primaryDarkest,
                    )
                ),
              ),
        ),

        backgroundColor:  MyColors.taintedWhite.withOpacity(0), // Colors.transparent,

        title: const Center(
          child: Text('Stranger', style: TextStyle(color:  MyColors.primaryDarkest, fontSize: 25.0, fontWeight: FontWeight.w900),),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0,),
            child: IconButton(
              icon: const Icon(
                Icons.person_add_alt_1, color:  MyColors.primaryDarkest, size: 40.0,
              ),
              onPressed: () => {
                print("Add Friend")
              },
            ),
          ),
        ],

        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header', textAlign: TextAlign.center,),
            ),
            ListTile(
              title: const Text('Home', textAlign: TextAlign.center,),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
              },
            ),
            ListTile(
              title: const Text('Friends', textAlign: TextAlign.center,),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsPage()),);
              },
            ),
            ListTile(
              title: const Text('Settings', textAlign: TextAlign.center,),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()),);
              },
            ),
            ListTile(
              title: const Text('Logout', textAlign: TextAlign.center,),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()),);
              },
            ),
          ],
        ),
      ),


      body: SingleChildScrollView( child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              DecoratedBox(
                decoration:
                const BoxDecoration(
                  color:  MyColors.taintedWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70.0),
                    topRight: Radius.circular(70.0),
                    bottomLeft: Radius.circular(70.0),
                    bottomRight: Radius.circular(70.0),
                  ),
                ),
                child:
                AspectRatio(
                  aspectRatio: 2,
                  child:
                  Image.asset(
                    'assets/images/Ragnar_Wallpaper.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: SizedBox(
                  height: 120,
                  width: 100,
                  child: Stack(
                    children: const [
                      FractionalTranslation(
                        translation: Offset(0.0, 0.5),
                        child: SizedBox(
                          height: 150,
                          width: 100,
                          child:
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xffF89D7D),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Color(0xffF89D7D),
                              backgroundImage: AssetImage('assets/images/NFT.jpeg'),
                            ),
                          ),
                          // Image.asset(
                          //   'assets/images/Tux.png',),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(top: 60.0,),
            child: const Text("Stranger's Name Here", style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.w300,
              color: Color(0xff4B5052),
              letterSpacing: 0.3,
            ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 60.0,),
            child: const Text('Gender | Age ??', style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              color: Color(0xff4B5052),
              letterSpacing: 1,
            ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 50.0,),
            child: const Text('City, Country', style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              color: Color(0xff4B5052),
              letterSpacing: 1,
            ),
            ),
          ),

          const Divider(height: 10, thickness: 5, indent: 160, endIndent: 160,),

          Container(
            margin: const EdgeInsets.only(top: 10.0,),
            child: const Text('About Me', style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w300,
              color: Color(0xff4B5052),
              letterSpacing: 1,
            ),
            ),
          ),

          const Divider(height: 20, thickness: 5, indent: 20, endIndent: 20,),

          Container(
            margin: const EdgeInsets.only(top: 5.0,),
            child: const Text(
              "Stranger's description will be here...",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w300,
                color: Color(0xff4B5052),
                letterSpacing: 1,
              ),
            ),
          ),

          const Divider(height: 20, thickness: 5, indent: 20, endIndent: 20,),

        ],
      ),),
    );
  }
}

