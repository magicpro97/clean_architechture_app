import 'package:clean_architechture_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architechture_app/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(
                        message: 'Start searching!',
                      );
                    } else if (state is Loaded) {
                      return TriviaDisplay(
                        numberTrivia: state.trivia,
                      );
                    } else if (state is Loading) {
                      return LoadingWidget();
                    } else if (state is Error) {
                      return MessageDisplay(
                        message: state.message,
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: textController,
                      decoration: InputDecoration(
                          hintText: 'Input a number',
                          border: OutlineInputBorder(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                      builder: (context, state) =>
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: MaterialButton(
                                    child: Text(
                                      'Search',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _searchNumberTrivia(
                                          context, textController.text);
                                    },
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  child: Text('Random'),
                                  onPressed: () {
                                    _getRandomNumberTrivia(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _searchNumberTrivia(BuildContext context, String text) {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(text));
  }

  void _getRandomNumberTrivia(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    Key key,
    this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            numberTrivia.number.toString(),
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
