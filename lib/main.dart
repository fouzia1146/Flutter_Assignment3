import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:picture_story_time/storyList.dart';

List<Story> storyList = [

];
Story story = Story(
  title: "Nature",
  coverImage: "assets/nature.jpg",
  content: "Nature",
);

void main() {

  for(var i = 0; i < allStory.length; i++){
    Story newStory = Story(title: allTitle[i], coverImage: allImageLink[i], content: allStory[i]);
    storyList.add(newStory);
  }
  runApp(const PictureStoryApp());
}

class PictureStoryApp extends StatelessWidget {
  const PictureStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picture Story Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StoryLibraryScreen(),
    );
  }
}

class StoryLibraryScreen extends StatelessWidget {
  const StoryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Library'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StoryAddScreen(),
            ),
          );
        },
      ),
      body: ListView.builder(
        itemCount: storyList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the story viewer screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryViewerScreen(story: storyList[index]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    storyList[index].coverImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    storyList[index].title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoryViewerScreen extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();
  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.5);
    await flutterTts.speak(text);
  }

  final Story story;

  StoryViewerScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              story.coverImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                story.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                speak(story.content);
              },
              child: const Text('Read Aloud'),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryAddScreen extends StatefulWidget{
  const StoryAddScreen({super.key});

  @override
  State<StoryAddScreen> createState() => _StoryAddScreen();
}

class _StoryAddScreen extends State<StoryAddScreen> {
  final titleInput = TextEditingController();
  final storyInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Library'),
        ),

        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3.5),
              // mainAxisAlignment: MainAxisAlignment.center,
              children:[
                TextFormField(
                  controller: titleInput,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Your Story Title',
                  ),
                ),
                TextFormField(
                  controller: storyInput,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Write Your Story Here!",
                  ),
                  minLines: null,
                  maxLines: null,
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: () =>{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoryLibraryScreen(),
                          ),
                        ),
                      },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(10.0),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("cancel")
                      ),

                      TextButton(
                          onPressed: () =>{
                            if(titleInput.text.isNotEmpty && storyInput.text.isNotEmpty){
                              storyList.add(Story(
                                  title: titleInput.text,
                                  coverImage: "assets/nature.jpg",
                                  content: storyInput.text),
                              ),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StoryLibraryScreen(),
                                ),
                              ),
                            }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: const Text("Please Fill all the Fields.", style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ) ),
                                      actions: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: TextButton(
                                              onPressed: ()=>{
                                                Navigator.pop(context)
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blueAccent,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Continue Editing!")
                                          ),
                                        )
                                      ],
                                    );
                                  })

                            }


                          },
                          style: TextButton.styleFrom(

                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.all(10.0),
                            foregroundColor: Colors.white,

                          ),
                          child: const Text("confirm")
                      )

                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}


class Story {
  final String title;
  final String coverImage;
  final String content;

  Story({
    required this.title,
    required this.coverImage,
    required this.content
  });
}