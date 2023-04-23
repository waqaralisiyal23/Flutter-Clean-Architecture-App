import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'src/config/themes/app_themes.dart';

import 'src/config/router/app_router.dart';
import 'src/domain/repositories/api_repository.dart';
import 'src/domain/repositories/database_repository.dart';
import 'src/locator.dart';
import 'src/presentation/cubits/local_articles/local_articles_cubit.dart';
import 'src/presentation/cubits/remote_articles/remote_articles_cubit.dart';
import 'src/utils/constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RemoteArticlesCubit(
            locator<ApiRepository>(),
          )..getBreakingNewsArticles(),
        ),
        BlocProvider(
          create: (context) => LocalArticlesCubit(
            locator<DatabaseRepository>(),
          )..getAllSavedArticles(),
        ),
      ],
      child: OKToast(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          routerConfig: AppRouter().config(),
          theme: AppTheme.light,
        ),
      ),
    );
  }
}
