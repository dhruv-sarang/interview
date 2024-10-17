import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview/preference/pref_manager.dart';
import '../../bloc/quiz/quiz_bloc.dart';
import '../add_question/add_question.dart';
import '../category/category_view.dart';
import '../login/login_screen.dart';
import '../quiz/quiz_view.dart';
import '../read_question/select_category_read.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB0BEC5), // light blue-grey
              Color(0xFFA3C1DA), // light blue-grey
              Color(0xFFA3C1DA), // light blue-grey
              Color(0xFFA3C1DA), // light blue-grey
              Color(0xFFB0BEC5), // light blue-grey
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              collapsedHeight: 200,
              backgroundColor: Colors.transparent,
              actions: [
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Hello,\n',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: PrefManager.getEmail()
                            .split('@gmail.com')
                            .first
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // background: Image.asset(
                //   'assets/images/Vector.png',
                //   fit: BoxFit.contain,
                //   color: Colors.black12,
                // ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 180),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<QuizBloc>().add(ResetQuizEvent());
                      index == 0
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  const QuizView(),
                              ))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SelectCategoryReadView(),
                              ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: Colors.black26,
                        child: Center(
                          child: Text(
                            index == 0 ? 'Play Quiz' : 'Read\nQuestions',
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: 2,
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Colors.grey[200],
          width: 250,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
                child: Text('Settings',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                title: const Text('Manage Category'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CategoryView()));
                },
              ),
              ListTile(
                title: const Text('Add Question'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddQuestion()));
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  showAlertDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('Are you sure you want to Logout'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // status(st, context);
              await PrefManager.logout()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false));
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }
}
