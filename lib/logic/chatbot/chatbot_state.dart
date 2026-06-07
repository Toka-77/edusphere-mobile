import 'package:equatable/equatable.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

/// Nothing happening — ready to accept input.
class ChatbotIdle extends ChatbotState {}

/// Waiting for the AI response.
class ChatbotLoading extends ChatbotState {}

/// AI returned a recommendation successfully.
class ChatbotResponseReceived extends ChatbotState {
  final String response;

  const ChatbotResponseReceived(this.response);

  @override
  List<Object?> get props => [response];
}

/// Something went wrong.
class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);

  @override
  List<Object?> get props => [message];
}
