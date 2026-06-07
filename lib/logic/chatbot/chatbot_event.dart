import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class SendChatMessage extends ChatbotEvent {
  final int studentId;
  final String message;

  const SendChatMessage({required this.studentId, required this.message});

  @override
  List<Object> get props => [studentId, message];
}
