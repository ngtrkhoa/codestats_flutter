import 'package:codestats_flutter/bloc/bloc_provider.dart';
import 'package:codestats_flutter/bloc/codestats_bloc.dart';
import 'package:codestats_flutter/models/user/user.dart';
import 'package:codestats_flutter/widgets/day_language_xps.dart';
import 'package:codestats_flutter/widgets/day_of_year_xps.dart';
import 'package:codestats_flutter/widgets/language_levels.dart';
import 'package:codestats_flutter/widgets/no_user.dart';
import 'package:codestats_flutter/widgets/profile_page.dart';
import 'package:codestats_flutter/widgets/random_loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DashBoardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc bloc = BlocProvider.of(context);

    return StreamBuilder(
      stream: CombineLatestStream(
        [bloc.userStateController as Stream, bloc.selectedUser, bloc.chosenTab],
        (values) => values,
      ),
      initialData: [null, null, 0],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        String currentUser = snapshot.data[1] ?? "";
        Map<String, User> users = snapshot.data[0]?.allUsers ?? {};
        User userModel = users[currentUser];

        int tabIndex = snapshot.data[2];

        if (currentUser != null &&
            currentUser.isNotEmpty &&
            userModel == null) {
          return Center(
            child: RandomLoadingAnimation(),
          );
        } else if (currentUser == null || currentUser.isEmpty) {
          if (users != null && users.isNotEmpty) {
            bloc.selectUser.add(users.keys.first);
          }
          return NoUser();
        } else {
          switch (tabIndex) {
            case 0:
              return ProfilePage(
                userModel: userModel,
                userName: currentUser,
              );
            case 1:
              return DayLanguageXpsWidget(
                userModel: userModel,
              );
            case 2:
              return LanguageLevelPage(
                userModel: userModel,
              );
            default:
              return DayOfYearXps(
                userModel: userModel,
                scrollController: ScrollController(),
              );
          }
        }
      },
    );
  }
}
