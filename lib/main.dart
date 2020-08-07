import 'package:canaokey/MainPages/Personal.dart';
import 'package:canaokey/Models/DataSave.dart';
import 'package:canaokey/Models/StreamBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MainPages/Home.dart';
import 'DrawerPages/HelpPage.dart';
import 'DrawerPages/AboutPage.dart';
import 'Models/Bloc.dart';

class LanBloc extends InheritedWidget {
  final LanguageBloc bloc;
  final Settings settings;

  const LanBloc(
    this.bloc,this.settings,
      {
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static LanBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanBloc>();
  }

  @override
  bool updateShouldNotify(LanBloc old) {
    return true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LanguageBloc bloc = LanguageBloc();
  Settings settings = await Functions.loadSettings(Settings.filename);
  runApp(LanBloc(bloc, settings, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: ScaffoldRoute());
  }
}

class ScaffoldRoute extends StatefulWidget {
  int selectedIndex = 0;

  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  List<Language> languages = [
    Language.English,
    Language.Chinese,
    Language.Japanese
  ];
  int currentLanguage;
  static HomeContent homeContent = new HomeContent();
  static PersonalContent personalContent = new PersonalContent();
  final _pageList = [homeContent, personalContent];

  @override
  void didChangeDependencies(){
    setState(() {
      currentLanguage = LanBloc.of(context).settings.currentLan;
    });
    super.didChangeDependencies();
  }

  radioDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
                content: Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                        groupValue: currentLanguage,
                        activeColor: Colors.blue,
                        value: 0,
                        onChanged: (value) {
                          state(() {
                            currentLanguage = value;
                            print(currentLanguage);
                          });
                        },
                      ),
                      Text('English'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        groupValue: currentLanguage,
                        activeColor: Colors.blue,
                        value: 1,
                        onChanged: (value) {
                          state(() {
                            currentLanguage = value;
                            print(currentLanguage);
                          });
                        },
                      ),
                      Text('中文')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        groupValue: currentLanguage,
                        activeColor: Colors.blue,
                        value: 2,
                        onChanged: (value) {
                          state(() {
                            currentLanguage = value;
                            print(currentLanguage);
                          });
                        },
                      ),
                      Text('日本語')
                    ],
                  ),
                  FlatButton(
                    child: Streambuilder('confirm',
                        TextStyle(fontSize: 16, color: Colors.white)),
                    color: Colors.green,
                    onPressed: () {
                      LanBloc.of(context)
                          .bloc
                          .languageSink
                          .add(languages[currentLanguage]);
                      LanBloc.of(context).settings.setCurrentLan(currentLanguage);
                      Functions.writeSettings(Settings.filename, LanBloc.of(context).settings);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Streambuilder('app_title', TextStyle(fontSize: 22)),
            actions: <Widget>[
              IconButton(
                icon: Image.asset('lib/Images/CanokeyLogo.png'),
              ),
            ]),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              ListTile(
                  leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              )),
              InkWell(
                child: ListTile(
                  //Settings
                  title: Streambuilder('about_page', TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.error,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AboutContent()));
                  });
                },
              ),
              InkWell(
                child: ListTile(
                  //Settings
                  title: Streambuilder('help_page', TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.help,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HelpContent()));
                  });
                },
              ),
              InkWell(
                child: ListTile(
                  title: Streambuilder('language', TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.language,
                    size: 30,
                  ),
                ),
                onTap: () {
                  radioDialog();
                },
              )
            ],
          ),
        ),
        //抽屉
        bottomNavigationBar: BottomNavigationBar(
          // 底部导航
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Streambuilder('home_page', TextStyle(fontSize: 14)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              title: Streambuilder('credentials_page', TextStyle(fontSize: 14)),
            ),
          ],
          currentIndex: widget.selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        body: IndexedStack(
          index: widget.selectedIndex,
          children: _pageList,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
}
