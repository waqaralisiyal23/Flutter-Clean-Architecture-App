import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/models/requests/breaking_news_request.dart';
import '../../../domain/repositories/api_repository.dart';

import '../../../domain/models/article.dart';
import '../../../utils/constants/nums.dart';
import '../../../utils/resources/data_state.dart';
import '../base/base_cubit.dart';

part 'remote_articles_state.dart';

class RemoteArticlesCubit
    extends BaseCubit<RemoteArticlesState, List<Article>> {
  final ApiRepository _apiRepository;
  int _page = 1;

  RemoteArticlesCubit(this._apiRepository)
      : super(const RemoteArticlesLoading(), []);

  Future<void> getBreakingNewsArticles() async {
    if (isBusy) return;

    await run(() async {
      final response = await _apiRepository.getBreakingNewsArticles(
        request: BreakingNewsRequest(page: _page),
      );

      if (response is DataSuccess) {
        final articles = response.data!.articles;
        final noMoreData = articles.length < defaultPageSize;

        data.addAll(articles);
        _page++;

        emit(RemoteArticlesSuccess(articles: data, noMoreData: noMoreData));
      } else if (response is DataFailed) {
        emit(RemoteArticlesFailed(error: response.error));
      }
    });
  }
}
