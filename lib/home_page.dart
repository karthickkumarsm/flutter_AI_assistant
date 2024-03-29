import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:marc/feature_box.dart';
import 'package:marc/openai_service.dart';
import 'package:marc/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final speechToText = SpeechToText();
  final flutterTts=FlutterTts();
  String lastWords='';
  final OpenAIService openAIService = OpenAIService();
  String? generatedImageUrl;
  String? generatedContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void>initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {
      
    });
  }

  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {
    });
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text("Enola AI")),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //AI Picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/virtualAssistant.png'))),
                  ),
                ],
              ),
            ),
            //chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl==null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Pallete.borderColor,
                      )),
                  child:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                     generatedContent==null ? "Good Morning! what task can I do for you?" : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent==null ? 25 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(generatedImageUrl!=null)
               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                   child: Image.network(
                                 generatedImageUrl!
                               ),
                 ),
               ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent==null && generatedImageUrl==null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10,left: 22),
                  child: const Text(
                    "Here are a few features",
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                ),
              ),
            ),
            //Features list
            Visibility(
              visible: generatedContent==null && generatedImageUrl==null,
              child:Column(
                children: [
                  SlideInRight(
                    delay: const Duration(milliseconds: 200),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: "ChatGPT",
                      descriptionText: "A Smarter way to stay organized and informed with ChatGPT",
                      ),
                  ),
                  SlideInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: "Dall-E",
                      descriptionText: "Get inspired and stay creative with your personal assistant powered by Dall-E",
                      ),
                  ),
                  SlideInRight(
                    delay: const Duration(milliseconds: 600),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: "Smart Voice Assistant",
                      descriptionText: "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                      ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: () async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }
            else if(speechToText.isListening){
             final speech = await openAIService.isArtPromptAPI(lastWords);
             if(speech.contains('https')){
              generatedImageUrl=speech;
              generatedContent=null;
              setState(() {
              });
             }
             else{
               generatedImageUrl=null;
              generatedContent=speech;
              setState(() {
              });
              await systemSpeak(speech);  
             }
              await stopListening();
            }
            else{
              initSpeechToText();
            }
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          child:Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
