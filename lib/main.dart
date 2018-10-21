import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizapp/quiz.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Quiz quiz;
  List<Results> results;
  Color c;
  Random random = Random();
  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    var res = await http.get("https://opentdb.com/api.php?amount=20");
    var decRes = jsonDecode(res.body);
    print(decRes);
    c = Colors.black;
    quiz = Quiz.fromJson(decRes);
    results = quiz.results;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        elevation: 0.0,
      ),
      body: quiz == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchQuestions,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) => Card(
                      color: Colors.white,
                      elevation: 0.0,
                      child: ExpansionTile(
                        title: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                results[index].question,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FilterChip(
                                      backgroundColor: Color(0xff000000 +
                                              random.nextInt(0x00ffffff))
                                          .withOpacity(0.4),
                                      label: Text(results[index].category),
                                      onSelected: (b) {},
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    FilterChip(
                                      backgroundColor: Color(0xff000000 +
                                              random.nextInt(0xff000000))
                                          .withOpacity(0.4),
                                      label: Text(results[index].difficulty),
                                      onSelected: (b) {},
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Text(
                              results[index].type.startsWith("m") ? "M" : "B"),
                        ),
                        children: results[index].allAnswers.map((m) {
                          return AnswerWidget(results, index, m);
                        }).toList(),
                      ),
                    ),
              ),
            ),
    );
  }
}

class AnswerWidget extends StatefulWidget {
  List<Results> results;
  int index;
  String m;

  AnswerWidget(this.results, this.index, this.m);

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          if (widget.m == widget.results[widget.index].correctAnswer) {
            c = Colors.green;
          } else {
            c = Colors.red;
          }
        });
      },
      title: Text(
        widget.m,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
