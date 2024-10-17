part of 'quiz_bloc.dart';

sealed class QuizEvent {}

class LoadQuizEvent extends QuizEvent {}

class UpdateSelectedOptionQuizEvent extends QuizEvent {
  final int selectedQuizOption;

  UpdateSelectedOptionQuizEvent({required this.selectedQuizOption});
}

class AnswerQuizEvent extends QuizEvent {
  final int selectedAnswer;

  AnswerQuizEvent({required this.selectedAnswer});
}

class ResetQuizEvent extends QuizEvent {}
