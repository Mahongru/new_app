import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dolphin_app/dolphin/dolphin.dart';

part 'widgets/background.dart';

class DolphinPage extends StatelessWidget {
  const DolphinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            DolphinBloc(RepositoryProvider.of<DolphinService>(context))
              ..add(InitialApiCall()),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Dolphin App'),
            ),
            body: Stack(children: const [
              Background(),
              ImageView(),
            ])));
  }
}

class ImageView extends StatelessWidget {
  const ImageView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DolphinBloc, DolphinState>(builder: (context, state) {
      if (state is InitialState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is DataLoadedState) {
        List<DolphinModel> dolphins = state.dolphins;
        int idx = state.index;
        if (idx == 4) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Image.network(dolphins[idx].url)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                FloatingActionButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () => BlocProvider.of<DolphinBloc>(context)
                        .add(InitialApiCall())),
              ])
            ],
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Image.network(dolphins[idx].url)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              FloatingActionButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () => BlocProvider.of<DolphinBloc>(context)
                      .add(NextImage(dolphins, idx))),
              FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () => BlocProvider.of<DolphinBloc>(context)
                      .add(NextImage(dolphins, idx))),
            ])
          ],
        );
      }

      if (state is DataErrorState) {
        return Center(
          child: Text('Error ${state.error}'),
        );
      }
      return Container();
    });
  }
}
