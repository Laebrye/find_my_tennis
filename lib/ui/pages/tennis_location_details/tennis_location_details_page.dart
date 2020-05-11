import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:find_my_tennis/ui/common_widgets/add_new_form.dart';
import 'package:find_my_tennis/ui/pages/tennis_location_details/tennis_club_card.dart';
import 'package:find_my_tennis/ui/pages/tennis_location_details/tennis_location_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:'
    'provider/provider.dart';

class TennisLocationDetailsPage extends StatelessWidget {
  static Widget create(BuildContext context, {TennisLocation tennisLocation}) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context);
    return Provider<TennisLocationDetailsBloc>(
      create: (_) => TennisLocationDetailsBloc(
        database: database,
        auth: auth,
        tennisLocation: tennisLocation,
      ),
      child: TennisLocationDetailsPage(),
    );
  }

  static const String id = 'tennis_location_details_page';

  Future<void> onFABTapped(BuildContext context) async {
    final bloc = Provider.of<TennisLocationDetailsBloc>(context, listen: false);
    await AddNewForm(
      onSubmit: (String name) => bloc.addTennisCLub(name),
      text: 'Add new Tennis Club',
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<TennisLocationDetailsBloc>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => onFABTapped(context),
      ),
      body: StreamBuilder<TennisLocationDetailsModel>(
        stream: bloc.tennisLocationDetailsModelStream,
        initialData: TennisLocationDetailsModel(isLoading: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            if (snapshot.data.isLoading == true) {
              return _buildLoading();
            }
            return _buildContent(
                context: context,
                bloc: bloc,
                tennisLocationDetailsModel: snapshot.data);
          }
          if (!snapshot.hasData) {
            return _buildEmpty();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildContent({
    BuildContext context,
    TennisLocationDetailsBloc bloc,
    TennisLocationDetailsModel tennisLocationDetailsModel,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 24,
        ),
        Container(
          alignment: Alignment.center,
          height: 120,
          child: Text(
            tennisLocationDetailsModel.tennisLocation.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tennisLocationDetailsModel.tennisClubList.length,
            itemBuilder: (BuildContext context, int index) {
              return TennisClubCard(
                tennisClub: tennisLocationDetailsModel.tennisClubList[index],
              );
            },
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Text(
          'oops! Something went wrong',
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
