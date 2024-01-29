import 'package:flutter/material.dart';
import 'package:news_app/screen/new_details.dart';
import 'package:news_app/service/news_service.dart';
import '/model/news_model.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final NewService _service = NewService();
  List<Result?> news = [];
  List<Result?> tempNews = [];
  int selectedCategoryIndex = 0;
  Map<String, String> categories= {
    'Gündem': 'general',
    'Ekonomi': 'economy',
    'Sağlık': 'health',
    'Teknoloji': 'technology',
    'Spor': 'sport',
  };
  bool? isLoading = true;

  getNews(String category){
    setState(() {
      isLoading = true;
      news = [];
    });
    _service.fetchNews(category).then((value){
      if(value != null && value.result != null){
        news = value.result!;
        tempNews = news;
        isLoading = false;
      }else{
        isLoading = null;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getNews('general');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 12
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Text('HABERLER',),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < categories.keys.length; i++)...[
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedCategoryIndex = i;
                      });
                      getNews(categories.values.toList()[i]);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: MediaQuery.sizeOf(context).width * 0.025
                      ),
                      margin:EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.005
                      ),
                      decoration: selectedCategoryIndex == i?BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)
                      ):BoxDecoration(),
                      child: Text(
                        categories.keys.toList()[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedCategoryIndex == i?Colors.white: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          SizedBox(height: 12,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0,
                horizontal: MediaQuery.sizeOf(context).width * 0.06
            ),
            child: Stack(
              children: [
                TextField(
                  cursorColor: Colors.black,
                  onChanged: (value){
                    news = [];
                    for(int n = 0; n < tempNews.length; n++){
                      if(
                      tempNews[n]!.name!.toLowerCase().contains(value.toLowerCase())
                          ||tempNews[n]!.description!.toLowerCase().contains(value.toLowerCase())
                      ){
                        news.add(tempNews[n]);
                      }
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      hintText: 'Haber Ara',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                      )),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Icon(Icons.search)),
                )
              ],
            ),
          ),
          SizedBox(height: 12,),
          Expanded(
            child: Center(
              child: isLoading == null?Container(
                child: Text('Haberler yüklenemedi.'),
              ):isLoading!?CircularProgressIndicator(
                color: Colors.black,
              ):Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDetails(
                            url: news[index]!.url!,
                            title: news[index]!.name!,
                          )));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(news[index]!.image!,
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height / 4.5,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8,),
                            Text(news[index]!.name!,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),

                            SizedBox(height: 4,),
                            Text(news[index]!.description!,style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700
                            ),),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}