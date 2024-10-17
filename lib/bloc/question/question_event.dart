part of 'question_bloc.dart';

sealed class QuestionEvent {}

class FetchCategories extends QuestionEvent {}

class FetchQuestions extends QuestionEvent {
  final int categoryId;

  FetchQuestions(this.categoryId);
}

class AddQuestionEvent extends QuestionEvent {
  final Question question;

  AddQuestionEvent(this.question);
}

class UpdateSelectedOptionEvent extends QuestionEvent {
  final int selectedOption;

  UpdateSelectedOptionEvent(this.selectedOption);
}

class DeleteQuestion extends QuestionEvent {
  final Question question;

  DeleteQuestion(this.question);
}
