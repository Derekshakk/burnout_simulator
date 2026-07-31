import '../models/character_profile.dart';
import '../models/game_scenario.dart';
import '../models/game_choice.dart';
import '../models/scene_artwork.dart';

// ──────────────────────────────────────────────────────────────────────────────
// SHARED SCENARIO A: Lunch Break
// Topics: Study Breaks · Socialising vs Recharging
// Characters: Alex  (S4 · 11:30 AM · high school)
//             Maya  (S3 · 11:00 AM · college)
//
// Character-specific effects:
//   Alex — ADHD framing: movement breaks, stim walk, sensory recovery;
//           four choices including a burnout-gated "skip lunch" option;
//           sets tags 'quiet_lunch' / 'stim_recovery' consumed by end_of_day.
//   Maya — AuDHD framing: sensory tools, fidget, invite-one-friend middle path;
//           three choices; sets tags 'maya_quiet_reset' / 'maya_socially_drained'
//           consumed by maya_critique.
// ──────────────────────────────────────────────────────────────────────────────
GameScenario buildLunchBreakScenario(CharacterProfile character) =>
    character.id == 'maya'
    ? _mayaLunchBreak(character)
    : _alexLunchBreak(character);

GameScenario _alexLunchBreak(CharacterProfile c) => GameScenario(
  id: 'shared_lunch_break',
  characterId: c.id,
  title: 'Lunch Break',
  timeLabel: '11:30 AM',
  sceneTone: 'lunch',
  sceneType: 'cafeteria',
  sceneArtwork: SceneArtworks.cafeteriaBackground,
  sceneSemanticLabel: 'Illustration of a school cafeteria at lunchtime',
  carryoverNotes: {
    'pushed_sensory':
        'The sensory pressure from this morning\'s crowded hallway hasn\'t fully lifted. The need for quiet feels urgent, not just preferable.',
    'masked_restless':
        '${c.name}\'s body and mind are both asking for something after holding restlessness in all morning. Food alone might not be enough.',
    'asked_movement_accommodation':
        'Asking the teacher for a movement accommodation this morning took something — and left something too. The lunch break feels different when less is being held in.',
  },
  description:
      '${c.name} has a free 30-minute lunch period. The cafeteria is loud and crowded. A quieter spot outside near the courtyard is open. ${c.name} has eaten only a granola bar since this morning.',
  narration:
      '"I need something. I\'m not sure if it\'s food, quiet, movement, or all three."',
  choices: [
    GameChoice(
      id: 'cafeteria_social',
      label: 'Eat in the cafeteria with classmates',
      description:
          'Sit with the usual group. The noise is significant, but so is the social connection.',
      energyDelta: -10,
      stressDelta: 10,
      motivationDelta: 5,
      lifeSatisfactionDelta: 5,
      focusDelta: -5,
      timeMinutesDelta: 30,
      educationalFeedback:
          'Social connection can be restorative for some people and draining for others — and often both at once. The cafeteria provided lunch and a sense of belonging, but the high sensory environment countered some of the benefit. The net effect depends on prior energy levels and what the rest of the afternoon holds.',
    ),
    GameChoice(
      id: 'quiet_spot_outside',
      label: 'Find a quiet spot outside with headphones and eat alone',
      description:
          'Take lunch outside to a less crowded area. Headphones, food, and 30 minutes of low stimulation.',
      energyDelta: 15,
      stressDelta: -20,
      focusDelta: 10,
      motivationDelta: 5,
      timeMinutesDelta: 30,
      tag: 'quiet_lunch',
      educationalFeedback:
          'Choosing a low-stimulation environment during lunch allowed ${c.name}\'s nervous system to partially recover. Eating and resting quietly restored energy more effectively than staying in high demand. Not all recovery looks like sleep — this is how many people with sensory sensitivities recharge.',
    ),
    GameChoice(
      id: 'stim_walk',
      label: 'Take a stim walk around the building, then eat',
      description:
          'Walk the perimeter of the school at a comfortable pace before eating. Rhythmic movement can help discharge accumulated sensory tension.',
      energyDelta: 10,
      stressDelta: -15,
      focusDelta: 5,
      motivationDelta: 10,
      timeMinutesDelta: 30,
      tag: 'stim_recovery',
      educationalFeedback:
          'Stimming — repetitive movement or self-soothing behaviors — is a natural self-regulation tool for many neurodivergent people. A rhythmic walk serves a similar function. Movement helps discharge accumulated stress and can improve focus for the next period. This is a valid strategy, not a habit to suppress.',
    ),
    GameChoice(
      id: 'skip_lunch_work',
      label: 'Skip eating and use the time to catch up on homework',
      description:
          'Use the lunch period for academic work instead of recovery.',
      energyDelta: -20,
      stressDelta: 15,
      focusDelta: -10,
      motivationDelta: -10,
      timeMinutesDelta: 30,
      maxBurnoutAllowed: 65,
      unavailableReason:
          '${c.name}\'s system is too depleted to focus on work without food or rest. When burnout is this high, skipping recovery time tends to compound the deficit rather than reduce it.',
      educationalFeedback:
          'Using recovery time for work output can feel productive but often produces diminishing returns. When energy and food are both low, cognitive performance degrades significantly. The tasks may take longer than they would after a proper break — and the cost of skipping rest carries forward into the afternoon.',
    ),
  ],
);

GameScenario _mayaLunchBreak(CharacterProfile c) => GameScenario(
  id: 'shared_lunch_break',
  characterId: c.id,
  title: 'The Between-Class Gap',
  timeLabel: '11:00 AM',
  sceneTone: 'lunch',
  sceneType: 'cafeteria',
  sceneArtwork: SceneArtworks.mayaCafeGroup,
  sceneSemanticLabel:
      'Illustration of Maya with a group in a café or student center',
  carryoverNotes: {
    'maya_split_attention':
        'After an hour of switching attention, even choosing lunch feels like another task. ${c.name}\'s body is asking for fewer inputs.',
    'maya_protected_focus':
        'Protecting one channel during studio left ${c.name} with enough bandwidth to notice what would actually help next.',
  },
  description:
      'There is a break before the next class. The student center is busy and a friend has invited ${c.name} to eat there. ${c.name} also needs food, a bathroom break, and a moment away from screens before the afternoon critique.',
  narration:
      '"I miss my friend, but I can feel the crowded room costing more than I have right now."',
  choices: [
    GameChoice(
      id: 'maya_push_social_lunch',
      label: 'Eat in the crowded student center and stay socially engaged',
      description:
          'Join the group even though the noise and conversation move quickly.',
      energyDelta: -14,
      stressDelta: 16,
      motivationDelta: 5,
      lifeSatisfactionDelta: 5,
      timeMinutesDelta: 40,
      tag: 'maya_socially_drained',
      educationalFeedback:
          'Connection can be meaningful and still be costly in a high-demand environment. The tradeoff is not a moral one: choosing social time may be right sometimes, while choosing regulation may be essential at other times. For many AuDHD people, knowing which one is needed requires ongoing attention to internal signals — and that attention itself has a cost.',
    ),
    GameChoice(
      id: 'maya_quiet_lunch',
      label: 'Take food to a quiet corner and use sensory tools',
      description:
          'Eat somewhere calm, use headphones or a fidget, and let the nervous system settle.',
      energyDelta: 15,
      stressDelta: -20,
      focusDelta: 10,
      timeMinutesDelta: 40,
      taskCompleted: 'Took a low-sensory lunch reset',
      tag: 'maya_quiet_reset',
      educationalFeedback:
          'A low-sensory lunch is active recovery. Food, quiet, movement, and sensory tools can restore capacity enough to make the afternoon more possible. Solitude in this context is regulation, not rejection. For people with both ADHD and autism, the sensory and executive-function demands of a busy social environment are compounded — quiet time is not optional.',
    ),
    GameChoice(
      id: 'maya_invite_one_friend',
      label: 'Invite one friend to eat in a quieter spot',
      description:
          'Suggest a bench outside the student center to keep connection while reducing sensory demand.',
      energyDelta: 7,
      stressDelta: -10,
      motivationDelta: 8,
      lifeSatisfactionDelta: 8,
      selfAdvocacyDelta: 10,
      timeMinutesDelta: 40,
      tag: 'maya_adapted_connection',
      educationalFeedback:
          'Adapting the setting can make connection more sustainable. Naming a different plan gives friends a concrete way to show care, and it avoids treating needs and relationships as competing priorities. This kind of low-stakes self-advocacy — changing the environment rather than suppressing the need — is a skill that builds over time.',
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────────────
// SHARED SCENARIO B: Academic Accommodations
// Topic: Academic Accommodations
// Characters: Jordan  (S5 · 2:00 PM · high school — IEP/504 framing)
//             Maya    (S5 · 2:30 PM · college — disability services framing)
//
// Character-specific effects:
//   Jordan — high-school counselor context; higher stress relief from seeking
//             support (sensory needs are more visible after today's challenges);
//             carryover from classroom_sensory_overload tags.
//   Maya   — college disability-services context; higher energy cost due to
//             additional self-initiation required (no automatic IEP continuation);
//             carryover from maya_critique tags.
// Both share the same three-choice structure and endTimeLabel: '3:00 PM'.
// ──────────────────────────────────────────────────────────────────────────────
GameScenario buildAccommodationsScenario(CharacterProfile character) {
  final bool isCollege = character.context.toLowerCase().contains('college');
  final bool isJordan = character.id == 'jordan';

  return GameScenario(
    id: 'shared_accommodations',
    characterId: character.id,
    title: 'Finding Support',
    timeLabel: isCollege ? '2:30 PM' : '2:00 PM',
    endTimeLabel: '3:00 PM',
    sceneTone: 'evening',
    sceneType: 'home',
    sceneArtwork: isJordan
        ? SceneArtworks.jordanBedroomRecovery
        : SceneArtworks.bedroomBackground,
    sceneSemanticLabel: isJordan
        ? 'Illustration of Jordan at home after a long school day'
        : 'Illustration of a quiet space at the end of the day',
    carryoverNotes: _accommodationsCarryover(isCollege),
    description: isCollege
        ? 'The disability services office is open until 5 PM. ${character.name} has been aware it exists since orientation but has not completed the intake process. In college, there is no automatic continuation from a school IEP — accessing accommodations requires self-initiation.'
        : 'The school counselor\'s office is open during this final period. ${character.name} has been managing the day\'s demands without formal support, but the challenges have been significant. An IEP or 504 plan could document accommodations that reduce the daily cost.',
    narration: isCollege
        ? '"I know what I need. Getting there — the forms, explaining it — feels like another full task."'
        : '"I know support is available. Asking for it is the part I keep putting off."',
    choices: [
      GameChoice(
        id: 'seek_accommodations',
        label: isCollege
            ? 'Email disability services to begin the intake process'
            : 'Visit the counselor\'s office to ask about formal accommodations',
        description: isCollege
            ? 'Send a short message today to start the process before the week ends.'
            : 'Go to the counselor\'s office and ask what accommodations are available.',
        energyDelta: isCollege ? -12 : -10,
        stressDelta: isCollege ? -8 : -12,
        selfAdvocacyDelta: 25,
        motivationDelta: 10,
        lifeSatisfactionDelta: 8,
        timeMinutesDelta: isCollege ? 30 : 60,
        taskCompleted: isCollege
            ? 'Contacted college disability services'
            : 'Initiated accommodations discussion with counselor',
        tag: 'accommodations_initiated',
        educationalFeedback: isCollege
            ? 'Accessing disability services in college requires self-initiation — there is no IEP or automatic continuation from high school. Taking the first step, even on a hard day, opens access to supports that reduce future load. Documentation in college can unlock extended time, flexible participation formats, and other adjustments that reduce the ongoing cost of masking and over-compensating.'
            : 'Asking for formal accommodations requires identifying what support would help — which is itself a skill. Counselors and IEP teams can translate those needs into documented support. Accommodations like extended time, sensory breaks, and quiet testing environments are designed to reduce the cost of demands that do not account for neurodivergent needs. Speaking up on hard days is harder — and also more necessary.',
      ),
      GameChoice(
        id: 'research_accommodations',
        label: isCollege
            ? 'Look up what accommodations are available before reaching out'
            : 'Check the school website to understand what accommodations exist',
        description:
            'Read what options are available before making the first request.',
        energyDelta: -5,
        stressDelta: -5,
        selfAdvocacyDelta: 10,
        focusDelta: 5,
        timeMinutesDelta: isCollege ? 30 : 60,
        taskCompleted: isCollege
            ? 'Researched college accommodation options'
            : 'Looked up available school accommodations',
        tag: 'accommodations_researched',
        educationalFeedback:
            'Researching available options before asking reduces the uncertainty of the first conversation. Knowing what exists — extended time, sensory accommodations, flexible participation formats, note-taking support — makes it easier to articulate what would help. Preparation is a form of self-advocacy, not avoidance of it.',
      ),
      GameChoice(
        id: 'manage_without_support',
        label: 'Continue managing independently for now',
        description: isCollege
            ? 'Decide the semester is nearly over and the process can wait until next term.'
            : 'Decide to keep managing without formal support for now.',
        energyDelta: -6,
        stressDelta: 8,
        selfAdvocacyDelta: -5,
        timeMinutesDelta: isCollege ? 30 : 60,
        tag: 'accommodations_deferred',
        educationalFeedback: isCollege
            ? 'Choosing to manage without formal support is a real and common decision. The process of requesting accommodations carries its own demands — disclosure, documentation, timing, and institutional navigation. The reasons for deferring are not always avoidance. And the ongoing costs of compensating without support also accumulate. This is worth revisiting when capacity allows.'
            : 'Managing without formal support is a choice many students make, for a range of reasons. The energy required to explain needs and navigate systems is real. Accommodations exist specifically to reduce the ongoing cost of compensating without them — not as a reward, but as a removal of unnecessary barriers. There is no wrong answer here, only a tradeoff that changes over time.',
      ),
    ],
  );
}

Map<String, String> _accommodationsCarryover(bool isCollege) {
  if (isCollege) {
    return {
      'maya_disclosed_to_instructor':
          'Having told the instructor what helps opens a path that formal documentation could widen. The question of accommodations now feels more concrete than abstract.',
      'maya_masked_critique':
          'Masking through the critique took something that documentation and flexible-format options could have preserved. Today made the gap between current support and what is available clearer.',
      'maya_processing_time':
          'Requesting processing time worked in the critique. Formal accommodations would make that available without having to ask each time.',
      'maya_visual_strength':
          'Using prepared visuals was effective. Knowing which formats work best is exactly the kind of information that accommodation planning is built on.',
    };
  }
  return {
    'endured_class_sensory':
        'After pushing through the afternoon without accommodation, arriving at this choice feels like the clearest possible case for what formal support could prevent.',
    'sensory_break_granted':
        'Taking a break during class pointed toward something: the support that made the break possible could be made more consistent through a formal plan.',
    'earplugs_classroom':
        'The earplugs helped today. A formal plan could build that option into the school day — and add others.',
  };
}
