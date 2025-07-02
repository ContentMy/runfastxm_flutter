import '../domain/models/guide_step.dart';
import 'strings.dart';

const guideSteps = [
  GuideStep(
    imageAsset: 'assets/images/guide/ui_main_guide_remind.png',
    title: Strings.guideRemindTitle,
    content: Strings.guideRemindContent,
  ),
  GuideStep(
    imageAsset: 'assets/images/guide/ui_main_guide_target.png',
    title: Strings.guideGoalTitle,
    content: Strings.guideGoalContent,
  ),
  GuideStep(
    imageAsset: 'assets/images/guide/ui_main_guide_memorandum.png',
    title: Strings.guideDiaryTitle,
    content: Strings.guideDiaryContent,
    isLast: true,
  ),
];
