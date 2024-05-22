class OnBoardingModel{
   String ?image;
   String ?dis;

   OnBoardingModel({
     this.image,
     this.dis,
  });
}

// dummy data
 List<OnBoardingModel> dataOnBoarding  = [
   OnBoardingModel(image: "assets/images/pic1.jpeg" , dis: "Call with your fired"),
   OnBoardingModel(image: "assets/images/pic2.jpeg" , dis: "Call with Ahmed"),
   OnBoardingModel(image: "assets/images/pic1.jpeg" , dis: "Call with  ali")
 ];