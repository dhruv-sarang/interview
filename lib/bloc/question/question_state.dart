part of 'question_bloc.dart';

sealed class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<Question> questions;

  QuestionLoaded(this.questions);
}

class QuestionError extends QuestionState {
  final String error;

  QuestionError(this.error);
}

class QuestionOptionUpdatedState extends QuestionState {
  final int selectedOption;

  QuestionOptionUpdatedState(this.selectedOption);
}

class QuestionDeleted extends QuestionState {
  final Question question;

  QuestionDeleted(this.question);
}
