import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/auth_actions.dart';
import '../models/app_state.dart';
import '../models/user.dart';

class MeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel viewModel) {
        print(viewModel.first_name);
        return RaisedButton(
            child: Text(viewModel.first_name != null ? (viewModel.first_name + ' ' + viewModel.last_name) : "Me"),
            onPressed: viewModel.onPressed
        );
      },
    );
  }
}

class _ViewModel {
  final Function() onPressed;
  final String first_name;
  final String last_name;
  final String picture;

  _ViewModel({this.onPressed, this.first_name, this.last_name, this.picture});

  static _ViewModel fromStore(Store<AppState> store) {
    User user = store.state.authState.user;

    return _ViewModel(
        onPressed: () {
          store.dispatch(UserMe());
        },
        first_name: user.first_name,
        last_name: user.last_name,
        picture: user.picture,
    );
  }
}
