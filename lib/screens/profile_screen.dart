
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../containers/logout_button.dart';
import '../containers/me_button.dart';
import '../models/app_state.dart';
import '../screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel viewModel) {
        if (viewModel.isAuthenticated) {
          print('viewModel');
          print(viewModel);
          print('picture');

          print(viewModel.picture);

          return ListView(
              children: <Widget>[
                LogoutButton(),
                MeButton(),

                viewModel.picture != null ? Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    viewModel.picture,
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 6,
                  margin: EdgeInsets.all(10),
                ) : Divider()
              ]
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class _ViewModel {
  final bool isAuthenticated;
  final String picture;

  _ViewModel({
    @required this.isAuthenticated,
    this.picture,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isAuthenticated: store.state.authState.isAuthenticated,
      picture: store.state.authState.user != null ? store.state.authState.user.picture : null,
    );
  }
}