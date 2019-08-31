import 'package:bloc_study/splash/splash_page.dart';
import 'package:bloc_study/user/user_repository.dart';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication.dart';
import 'common/loading_indicator.dart';
import 'home/home.dart';
import 'login/login_page.dart';

/*定义用来监听所有的Bloc 事件*/
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  /*定义用来监听所有的Bloc 事件*/
  BlocSupervisor.delegate = SimpleBlocDelegate();
  /*定义了一堆异步方法 用来模拟 获取 删除token*/
  final userRepository = UserRepository();
  runApp(
    /*设置最外层的Bloc*/
    BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..dispatch(AppStarted());//第一次默认拦截
      },
      child: App(userRepository: userRepository),
    ),
  );
}



class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
           /*显示主页 包含一个退出按钮*/
          if (state is AuthenticationAuthenticated) {
            return HomePage();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        },
      ),
    );
  }
}
