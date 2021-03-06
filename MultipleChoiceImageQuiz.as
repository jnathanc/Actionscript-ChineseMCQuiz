﻿package 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.display.DisplayObjectContainer;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author ...
	 */
	
	/* Class to be exported from Flash
	 * Required instances from Flash
	 * 	imageFrame
	 *  speaker_mc
	 *  answerBox1 - contains TextField called answer_txt and check and X
	 *  answerBox2 - contains TextField called answer_txt
	 *  answerBox3 - contains TextField called answer_txt
	 *  answerBox4 - contains TextField called answer_txt
	 * 
	 */
	public class MultipleChoiceImageQuiz extends MovieClip
	{		
		private var questions:Array = new Array();
		private var numQuestions:int = 0;
		private var qIndex:int = 0;
		private const ASSETS_PATH:String = "assets/"
		private const AUDIO_FOLDER:String = "audio/";
		private var currentImage:DisplayObject;
		private var nextQuestionTimer:Timer = new Timer(500, 1);
		private var IMAGE_FRAME_WIDTH:int;
		private var IMAGE_FRAME_HEIGHT:int;
		private var correct:int = 0;		
		
		// sound
		private var soundChannel:SoundChannel = new SoundChannel();
		private var sound:Sound = new Sound();
		
		public function MultipleChoiceImageQuiz() {
			answerBox1.buttonMode = true;
			answerBox2.buttonMode = true;
			answerBox3.buttonMode = true;
			answerBox4.buttonMode = true;
			
			answerBox1.X.visible = false;
			answerBox2.X.visible = false;
			answerBox3.X.visible = false;
			answerBox4.X.visible = false;
			
			answerBox1.check.visible = false;
			answerBox2.check.visible = false;
			answerBox3.check.visible = false;
			answerBox4.check.visible = false;
			
			
			IMAGE_FRAME_WIDTH = imageFrame.width;
			IMAGE_FRAME_HEIGHT = imageFrame.height;
			
			scoreScreen.visible = false;
			scoreScreen.restart_btn.addEventListener(MouseEvent.CLICK, restartQuiz);
			scoreScreen.restart_btn.buttonMode = true;
			
			scoreScreen.selectLesson_btn.addEventListener(MouseEvent.CLICK, gotoStartScreen);
			home_btn.addEventListener(MouseEvent.CLICK, gotoStartScreen);
			home_btn.buttonMode = true;
			
			right_btn.buttonMode = true;
		}
		
		public function startQuiz(questionXML:XML):void {
			getQuestionsFromXML(questionXML);
			constructQuestion(qIndex);
			initMouseListeners();
			initTimer();
		}
		
		private function getQuestionsFromXML(questionsXML:XML):void {	
			numQuestions = 0;
			var question:Question;
			for each(var xml:XML in questionsXML.question) {
				question = new Question(xml.questionText, xml.image, xml.audio, xml.correctAnswer, 
										[xml.distractor[0], xml.distractor[1],
										xml.distractor[2]]);
				questions.push(question);
				numQuestions++;
			}			
			// randomize questions
			questions = suffleArray(questions);
		}
		
		private function nextQuestion(evt:TimerEvent):void {
			resetAnswerBoxes();
			qIndex++;
			if (qIndex >= numQuestions) {
				//end
				showScore();
				return;
			}
			constructQuestion(qIndex);
		}
		
		private function showScore():void {
			scoreScreen.firstAttempt_txt.text = correct + " / " + numQuestions;
			scoreScreen.percentCorrect_txt.text = (correct / numQuestions * 100).toFixed(0) + " %";
			scoreScreen.visible = true;
		}
		
		private function skipQuestion():void {
			//right_btn.visible = false;
			resetAnswerBoxes();
			var question:Question = questions.splice(qIndex, 1)[0];
			question.skipped = true;
			questions.push(question); // Places skipped questions at the end of quiz.
			//qIndex++;
			//if (qIndex >= numQuestions - 1) {
				//end
				//return;
			//}
			constructQuestion(qIndex);
		}
		
		private function resetAnswerBoxes():void {
			answerBox1.gotoAndStop(1);
			answerBox2.gotoAndStop(1);
			answerBox3.gotoAndStop(1);
			answerBox4.gotoAndStop(1);
			
			answerBox1.X.visible = false;
			answerBox2.X.visible = false;
			answerBox3.X.visible = false;
			answerBox4.X.visible = false;
			
			answerBox1.check.visible = false;
			answerBox2.check.visible = false;
			answerBox3.check.visible = false;
			answerBox4.check.visible = false;
		}
		
		private function constructQuestion(questionIndex:int):void {
			var question:Question = questions[questionIndex];
			
			if (question.questionPath != "") {
				loadImage(ASSETS_PATH + question.questionPath);
			}else{
				question_txt.text = question.questionText;
			}
			
			if(question.audio != ""){
				loadAudio(ASSETS_PATH + AUDIO_FOLDER + question.audio);
				speaker_mc.visible = true;
			}else {
				speaker_mc.visible = false;
			}
			
			randomlyPlaceAnswers(question);
			
			repeat_txt.visible = question.skipped;
		}
		
		private function initMouseListeners():void {
			answerBox1.addEventListener(MouseEvent.CLICK, responseClicked);
			answerBox2.addEventListener(MouseEvent.CLICK, responseClicked);
			answerBox3.addEventListener(MouseEvent.CLICK, responseClicked);
			answerBox4.addEventListener(MouseEvent.CLICK, responseClicked);
			
			right_btn.addEventListener(MouseEvent.CLICK, rightClick);
			speaker_mc.addEventListener(MouseEvent.CLICK, speakerClick);
		}
		
		private function initTimer():void {
			nextQuestionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, nextQuestion);			
		}
		
		private function speakerClick(evt:MouseEvent):void {
			sound.play();
		}
		
		private function responseClicked(evt:MouseEvent):void {
			if (nextQuestionTimer.running)
				return;
			var response:Object = evt.currentTarget;
			var responseText:String = "";
			var responseObj:MovieClip;
			switch(response) {
				case answerBox1 :
					responseText = answerBox1.answer_txt.text;
					responseObj = answerBox1;
					break;
				case answerBox2 :
					responseText = answerBox2.answer_txt.text;
					responseObj = answerBox2;
					break;
				case answerBox3 :
					responseText = answerBox3.answer_txt.text;
					responseObj = answerBox3;
					break;
				case answerBox4 :
					responseText = answerBox4.answer_txt.text;
					responseObj = answerBox4;
					break;	
				default :
					return;
			}
			checkResponse(responseText,responseObj);
		}
		
		private function rightClick(evt:MouseEvent):void {
			skipQuestion();
		}
		
		private function checkResponse(response:String,responseObj:MovieClip):void {
			var question:Question = questions[qIndex];
			var correctResponse:String = question.correctAnswer;
			if (response == correctResponse) {
				responseObj.gotoAndStop(3);
				nextQuestionTimer.start();
				responseObj.check.visible = true;
				if (question.attemptNum == 1)
					correct++;
			}else {
				responseObj.gotoAndStop(4);
				responseObj.X.visible = true;
				question.attemptNum++;
			}
		}
		
		private function loadImage(path:String):void {
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(path);
			loader.load(urlRequest);
			imageFrame.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, adjustImage);
			currentImage = loader;
		}
		
		private function loadAudio(path:String):void {
			var request:URLRequest = new URLRequest(path);
			sound = new Sound(request);
			soundChannel = sound.play();
			sound.addEventListener(IOErrorEvent.IO_ERROR, soundErrorHandler);
		}
		
		private function soundErrorHandler(evt:IOErrorEvent):void {
			trace("There was an error loading"+questions[qIndex].audio+". Check that the file in the correct folder with the correct name.");
		}
		
		// fits the image to the imageFrame maintaning the images aspec ration and centers the image.
		private function adjustImage(evt:Event):void {
			var image:DisplayObject = currentImage;
			var imageWOH:Number = image.width / image.height;
			var containerWOH:Number = IMAGE_FRAME_WIDTH / IMAGE_FRAME_HEIGHT;
			if (imageWOH > containerWOH) {
				image.width = IMAGE_FRAME_WIDTH;
				image.height = image.width / imageWOH;
			} else {
				image.height = IMAGE_FRAME_HEIGHT;
				image.width = image.height * imageWOH;
			}
			image.x = (IMAGE_FRAME_WIDTH - image.width) / 2;
		}
		
		private function randomlyPlaceAnswers(question:Question):void {
			var answers:Array = question.distractors.concat(question.correctAnswer);
			answers = suffleArray(answers);
			answerBox1.answer_txt.text = answers[0];
			answerBox2.answer_txt.text = answers[1];
			answerBox3.answer_txt.text = answers[2];
			answerBox4.answer_txt.text = answers[3];
		}
		
		private function restartQuiz(evt:MouseEvent=null):void {
			scoreScreen.visible = false;
			qIndex = 0;
			correct = 0;
			resetAttempts();
			resetAnswerBoxes();
			constructQuestion(qIndex);
		}
		
		private function resetAttempts():void {
			for each(var question:Question in questions) {
				question.attemptNum = 1;
				question.skipped = false;
			}
		}
		
		private function gotoStartScreen(evt:MouseEvent):void {
			questions = [];
			scoreScreen.visible = false;
			qIndex = 0;
			correct = 0;
			resetAnswerBoxes();
			this.visible = false;
			MCImageQuiz(parent).startScreen.visible = true;
		}
		
		// A utility function used to randomize any array.
		private function suffleArray(array:Array):Array {			
			var shuffledArray:Array = new Array(array.length);			 
			var randomPos:Number = 0;
			for (var i:int = 0; i < shuffledArray.length; i++)
			{
				randomPos = int(Math.random() * array.length);
				shuffledArray[i] = array.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element
			}
			return shuffledArray;
		}
	}
	
}