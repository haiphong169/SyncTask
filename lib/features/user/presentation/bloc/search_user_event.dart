sealed class SearchUserEvent {}

class SearchQueryChanged extends SearchUserEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchCleared extends SearchUserEvent {}

class ResultTapped extends SearchUserEvent {
  final String resultUid;
  ResultTapped(this.resultUid);
}

class UserInvited extends SearchUserEvent {
  final String resultUid;
  UserInvited(this.resultUid);
}
