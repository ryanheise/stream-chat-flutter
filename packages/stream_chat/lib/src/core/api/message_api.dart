import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/message.dart';

///
class MessageApi {
  ///
  MessageApi(this._client);

  final StreamHttpClient _client;

  /// Sends the [message] to the given [channelId] of given [channelType]
  Future<SendMessageResponse> sendMessage(
    String channelId,
    String channelType,
    Message message,
  ) async {
    final response = await _client.post(
      '/channels/$channelType/$channelId/message',
      data: {'message': message},
    );
    return SendMessageResponse.fromJson(response.data);
  }

  /// Retrieves a list of messages by [messageIDs]
  /// from the given [channelId] of type [channelType]
  Future<GetMessagesByIdResponse> getMessagesById(
    String channelId,
    String channelType,
    List<String> messageIDs,
  ) async {
    final response = await _client.get(
      '/channels/$channelType/$channelId/messages',
      queryParameters: {'ids': messageIDs.join(',')},
    );
    return GetMessagesByIdResponse.fromJson(response.data);
  }

  /// Get a message by [messageId]
  Future<GetMessageResponse> getMessage(String messageId) async {
    final response = await _client.get(
      '/messages/$messageId',
    );
    return GetMessageResponse.fromJson(response.data);
  }

  /// Updates the given [message]
  Future<UpdateMessageResponse> updateMessage(
    Message message,
  ) async {
    final response = await _client.post(
      '/messages/${message.id}',
      data: {'message': message},
    );
    return UpdateMessageResponse.fromJson(response.data);
  }

  /// Deletes the given [messageId]
  Future<EmptyResponse> deleteMessage(
    String messageId,
  ) async {
    final response = await _client.delete(
      '/messages/$messageId',
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Send action for a specific [messageId]
  /// of the given [channelId] of given [channelType]
  Future<SendActionResponse> sendAction(
    String channelId,
    String channelType,
    String messageId,
    Map<String, Object?> formData,
  ) async {
    final response = await _client.post(
      '/messages/$messageId/action',
      data: {
        'id': channelId,
        'type': channelType,
        'form_data': formData,
        'message_id': messageId,
      },
    );
    return SendActionResponse.fromJson(response.data);
  }

  /// Send a [reactionType] for this [messageId]
  /// Set [enforceUnique] to true to remove the existing user reaction
  Future<SendReactionResponse> sendReaction(
    String messageId,
    String reactionType, {
    Map<String, Object?> extraData = const {},
    bool enforceUnique = false,
  }) async {
    final reaction = Map<String, Object?>.from(extraData)
      ..addAll({'type': reactionType});

    final response = await _client.post(
      '/messages/$messageId/reaction',
      data: {
        'reaction': reaction,
        'enforce_unique': enforceUnique,
      },
    );
    return SendReactionResponse.fromJson(response.data);
  }

  /// Delete a [reactionType] from this [messageId]
  Future<EmptyResponse> deleteReaction(
    String messageId,
    String reactionType,
  ) async {
    final response = await _client.delete(
      '/messages/$messageId/reaction/$reactionType',
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Get all the reactions for a [messageId]
  Future<QueryReactionsResponse> getReactions(
    String messageId,
    PaginationParams options,
  ) async {
    final response = await _client.get(
      '/messages/$messageId/reactions',
      queryParameters: {
        ...options.toJson(),
      },
    );
    return QueryReactionsResponse.fromJson(response.data);
  }

  /// Translates the [messageId] in provided [language]
  Future<TranslateMessageResponse> translateMessage(
    String messageId,
    String language,
  ) async {
    final response = await _client.post(
      '/messages/$messageId/translate',
      data: {'language': language},
    );
    return TranslateMessageResponse.fromJson(response.data);
  }

  /// Lists all the message replies for the [parentId]
  Future<QueryRepliesResponse> getReplies(
    String parentId,
    PaginationParams options,
  ) async {
    final response = await _client.get(
      '/messages/$parentId/replies',
      queryParameters: {
        ...options.toJson(),
      },
    );
    return QueryRepliesResponse.fromJson(response.data);
  }
}