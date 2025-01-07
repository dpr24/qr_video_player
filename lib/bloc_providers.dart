import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_video_player/screens/home/bloc/home_bloc.dart';

class ProvidersList {
  static List<BlocProvider> providers = [
    BlocProvider<HomeBloc>(create: (ctx) => HomeBloc())
  ];
}
