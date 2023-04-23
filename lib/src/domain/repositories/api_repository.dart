import '../models/responses/breaking_news_response.dart';

import '../../utils/resources/data_state.dart';
import '../models/requests/breaking_news_request.dart';

abstract class ApiRepository {
  Future<DataState<BreakingNewsResponse>> getBreakingNewsArticles(
      {required BreakingNewsRequest request});
}
