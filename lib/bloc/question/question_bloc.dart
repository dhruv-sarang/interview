import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/db_helper.dart';
import '../../model/question.dart';

part 'question_event.dart';

part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final DbHelper _dbHelper = DbHelper();
  int selectedOption = 1;

  QuestionBloc() : super(QuestionInitial()) {
    on<FetchQuestions>((event, emit) async {
      emit(QuestionLoading());
      try {
        List<Question> questions =
            await _dbHelper.getCategoryQuestion(event.categoryId);
        emit(QuestionLoaded(questions));
      } catch (e) {
        emit(QuestionError(e.toString()));
      }
    });

    on<AddQuestionEvent>((event, emit) async {
      try {
        int result = await _dbHelper.insertQuestion(event.question);
        if (result != -1) {
          event.question.qid = result;
          if (state is QuestionLoaded) {
            final currentState = state as QuestionLoaded;
            emit(QuestionLoaded([...currentState.questions, event.question]));
          }
        }
      } catch (e) {
        emit(QuestionError(e.toString()));
      }
    });

    on<UpdateSelectedOptionEvent>((event, emit) {
      selectedOption = event.selectedOption;
      emit(QuestionOptionUpdatedState(selectedOption));
    });

    on<DeleteQuestion>((event, emit) async {
      try {
        await _dbHelper.deleteQuestion(event.question.qid);
        final currentState = state;
        if (currentState is QuestionLoaded) {
          List<Question> updatedList = currentState.questions
              .where((cat) => cat.qid != event.question.qid)
              .toList();
          emit(QuestionLoaded(updatedList));
        }
      } catch (e) {
        emit(QuestionError(e.toString()));
      }
    });
  }
}
