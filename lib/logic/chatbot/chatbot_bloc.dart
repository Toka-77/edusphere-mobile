import 'package:flutter_bloc/flutter_bloc.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';
import '../../data/services/chatbot_service.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotService chatbotService;

  ChatbotBloc({required this.chatbotService}) : super(ChatbotIdle()) {
    on<SendChatMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendChatMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    try {
      final response =
          await chatbotService.sendMessage(event.studentId, event.message);
      emit(ChatbotResponseReceived(response));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }
}
