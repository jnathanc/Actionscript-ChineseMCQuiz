package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MCImageQuiz extends MovieClip 
	{
		private var xmlLoader:XMLLoader = new XMLLoader();
		private const XML_PATH:String = "assets/questions.xml";
		private var xml:XML;
		
		public function MCImageQuiz() {
			Multitouch.inputMode = MultitouchInputMode.NONE;
			loadXML();
			mciquiz.visible = false;
		}
		
		private function loadXML():void {
			xmlLoader.loadXML(XML_PATH);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}	
		
		private function xmlLoaded(evt:Event):void {			
			//getQuestionsFromXML(xmlLoader.data);	
			xml = XML(xmlLoader.data);
			initLessonButtons();
		}		
		
		private function initLessonButtons():void {
			startScreen.numbers_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson1_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson2_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson3_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson4_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson5_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson6_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
			startScreen.lesson7_btn.addEventListener(MouseEvent.CLICK, buttonClicked);
		}
		
		private function buttonClicked(evt:MouseEvent):void {
			var quizXML:XML;
			switch(evt.currentTarget) {
				case startScreen.numbers_btn:
					quizXML = xml.numbers[0];
					break;
				case startScreen.lesson1_btn:
					quizXML = xml.lesson1[0];
					break;
				case startScreen.lesson2_btn:
					quizXML = xml.lesson2[0];
					break;
				case startScreen.lesson3_btn:
					quizXML = xml.lesson3[0];
					break;
				case startScreen.lesson4_btn:
					quizXML = xml.lesson4[0];
					break;
				case startScreen.lesson5_btn:
					quizXML = xml.lesson5[0];
					break;
				case startScreen.lesson6_btn:
					quizXML = xml.lesson6[0];
					break;
				case startScreen.lesson7_btn:
					quizXML = xml.lesson7[0];
					break;
				default :
					return;
			}
			launchMCIQuiz(quizXML);
		}
		
		private function launchMCIQuiz(xml:XML):void {
			mciquiz.visible = true;
			startScreen.visible = false;
			mciquiz.startQuiz(xml);
		}
		

	}
	
}