import 'package:flutter/material.dart';

import 'package:squch_driver/core/place_service/place_provider.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  PlaceApiProvider placeApiProvider;
  bool loading =false;
  List<Suggestion> suggession =[];
  AddressSearch(
      this.placeApiProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion("",""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      // We will put the api call here+

      future: _callApi("test","en"),
      builder: (context, snapshot) => query == ''
          ? Container(
        padding: EdgeInsets.all(16.0),
        child: Text('Enter your address'),
      )
          : !loading && suggession.isNotEmpty
          ? ListView.builder(
        itemBuilder: (context, index) => ListTile(
          // we will display the data returned from our future here
          title:
          Text(/*snapshot.data[index]*/suggession[index].description),
          onTap: () {
          //  close(context, snapshot.data[index]);
          },
        ),
        itemCount: /*snapshot.data.length*/suggession.length,
      )
          : loading ? Container(child: Text('Loading...'))
      : Container(child: Text('No data found...')),
    );

  }

  _callApi(String input, String language) async{
    loading = true;
    suggession = await placeApiProvider.fetchSuggestions(input,language);
    loading =false;
  }
}

