import 'package:agriculture_app/screens/screen_widgets.dart/retry_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../helper/strings.dart';
import '../cubits/app/app_details_cubit.dart';
import '../helper/widgets.dart';

class AppDetailsScreen extends StatefulWidget {
  final String title;
  final String type;
  const AppDetailsScreen({Key? key, required this.title, required this.type})
      : super(key: key);
  static route(Map map) {
    return BlocProvider<AppDetailsCubit>(
      create: (_) => AppDetailsCubit(),
      child: AppDetailsScreen(
        title: map['title'] as String,
        type: map['type'] as String,
      ),
    );
  }

  @override
  _AppDetailsScreenState createState() => _AppDetailsScreenState();
}

class _AppDetailsScreenState extends State<AppDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getAppDetails();
  }

  void getAppDetails() {
    Future.delayed(Duration.zero, () {
      context.read<AppDetailsCubit>().getAppDetails(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppbar(context, widget.title),
      body: BlocConsumer<AppDetailsCubit, AppDetailsState>(
        listener: (context, state) {
          if (state is AppDetailsFetchFailure) {
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is AppDetailsFetchInProgress || state is AppDetailsIntial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AppDetailsFetchSuccess) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: buildHtmlContent(state.details),
                ),
              ),
            );
          }

          return RetryButton(
            onPressed: getAppDetails,
          );
        },
      ),
    );
  }
}
