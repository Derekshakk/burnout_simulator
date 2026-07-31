import '../models/game_scenario.dart';
import '../models/game_choice.dart';
import '../models/scene_artwork.dart';

const List<GameScenario> jordanScenarios = [
  // S1 — Room Change (unchanged)
  GameScenario(
    id: 'routine_disruption',
    characterId: 'jordan',
    title: 'Room Change',
    timeLabel: '8:30 AM',
    sceneTone: 'morning',
    sceneType: 'hallway',
    sceneArtwork: SceneArtworks.jordanHallway,
    sceneSemanticLabel:
        'Illustration of Jordan in a school hallway facing an unexpected room change',
    description:
        'Jordan arrives at the usual classroom to find a note taped to the door: the room has been moved to a different wing, effective today. No email. No prior announcement. The new room number is unfamiliar. Other students brush past, seemingly already aware.',
    narration:
        '"This was not what I prepared for. I rehearsed this morning — this hallway, this door. None of that applies now."',
    choices: [
      GameChoice(
        id: 'freeze_and_panic',
        label:
            'Stand frozen in the hallway, overwhelmed by the unexpected change',
        description:
            'The disruption is too abrupt. Jordan\'s mental plan doesn\'t have a fallback for this. Arrives to the new room late.',
        energyDelta: -20,
        stressDelta: 30,
        focusDelta: -20,
        selfAdvocacyDelta: -5,
        timeMinutesDelta: 20,
        tag: 'routine_panic',
        educationalFeedback:
            'Unexpected changes to routine can trigger a freeze response in autistic people, particularly when the disruption occurs at a transition point they had mentally prepared for. This is not a failure of flexibility — it reflects a genuine mismatch between an environment designed without predictability and a nervous system that relies on it. The freeze response is neurological, not a character flaw.',
      ),
      GameChoice(
        id: 'check_map_breathe',
        label:
            'Take three slow breaths, find the posted map, locate the new room calmly',
        description:
            'Pause, use a brief grounding technique, consult the map on the nearby wall, and navigate to the correct room.',
        energyDelta: -10,
        stressDelta: 5,
        focusDelta: 5,
        timeMinutesDelta: 15,
        tag: 'routine_adapted',
        educationalFeedback:
            'Using a brief grounding technique before acting — rather than reacting immediately — gave Jordan\'s nervous system time to shift gears. Consulting a posted map is a concrete strategy that works even when mental preparation has been disrupted. Adapting to unexpected changes takes more effort for autistic people, and that effort is real, even when the outcome looks smooth from the outside.',
      ),
      GameChoice(
        id: 'ask_passing_student',
        label: 'Ask a nearby student if they know where the new room is',
        description:
            'Initiate brief, practical social contact to get the information needed quickly.',
        energyDelta: -8,
        stressDelta: -5,
        selfAdvocacyDelta: 10,
        timeMinutesDelta: 10,
        taskCompleted: 'Navigated unexpected schedule change',
        tag: 'asked_for_help',
        educationalFeedback:
            'Asking for practical help from a peer is a form of self-advocacy that can be easier or harder depending on the social demands involved. When it works, it efficiently resolves an immediate problem. Practicing this kind of low-stakes request can build confidence for higher-stakes situations later. The effort to initiate social contact is not trivial and is worth recognizing.',
      ),
    ],
  ),

  // S2 — Unstructured Group Work (fixed: time 9:00 AM; carryover added for S1 positive paths)
  GameScenario(
    id: 'group_work_ambiguous',
    characterId: 'jordan',
    title: 'Unstructured Group Work',
    timeLabel: '9:00 AM',
    sceneTone: 'class',
    sceneType: 'classroom',
    sceneArtwork: SceneArtworks.jordanClassroom,
    sceneSemanticLabel:
        'Illustration of Jordan during unstructured group work in the classroom',
    carryoverNotes: {
      'routine_panic':
          'After the morning disruption, Jordan arrived in class already depleted. The ambiguity of the group project stacked on a nervous system that hadn\'t finished resetting.',
      'routine_adapted':
          'The grounding technique helped, but adapting still took something. Jordan arrived at class aware that the day was already asking more than planned for.',
      'asked_for_help':
          'Asking that nearby student worked. Jordan arrived with a small sense that asking is sometimes the fastest way through.',
    },
    description:
        'The teacher announces a group project, assigns groups at random, and distributes a vague instruction sheet. Phrases like "be creative" and "demonstrate your understanding" appear without rubric or clear success criteria. Jordan\'s group immediately begins talking over each other without a shared direction.',
    narration:
        '"What does \'demonstrate understanding\' mean for a grade? I can\'t start without knowing what I\'m aiming for. Why is everyone just guessing?"',
    choices: [
      GameChoice(
        id: 'stay_quiet_follow',
        label:
            'Stay quiet and try to follow along, guessing at what\'s expected',
        description:
            'Don\'t draw attention. Try to piece together expectations from the group\'s behavior and hope it\'s enough.',
        energyDelta: -20,
        stressDelta: 25,
        focusDelta: -15,
        selfAdvocacyDelta: -10,
        timeMinutesDelta: 60,
        tag: 'masked_confusing',
        educationalFeedback:
            'Attempting to mask confusion and infer unstated expectations is exhausting and often unsuccessful. The cognitive load of simultaneously decoding social cues and guessing at academic criteria is significant. This experience is common for autistic students in unstructured group settings. The result — high stress, low focus, low output — is a consequence of the environment, not a personal limitation.',
      ),
      GameChoice(
        id: 'ask_teacher_criteria',
        label:
            'Ask the teacher to clarify the grading criteria before the group starts',
        description:
            'Raise a hand and ask what specific outcomes the teacher is looking for and how the project will be evaluated.',
        energyDelta: -10,
        stressDelta: -10,
        selfAdvocacyDelta: 20,
        focusDelta: 15,
        timeMinutesDelta: 70,
        taskCompleted: 'Clarified assignment expectations',
        tag: 'sought_clarity',
        educationalFeedback:
            'Asking for clear criteria is a form of academic self-advocacy. For many autistic students, ambiguous instructions are genuinely harder to work with — not a matter of preference. Requesting specificity benefits everyone in the class but may require more social effort for some students. A nonjudgmental response from the teacher models that asking is safe.',
      ),
      GameChoice(
        id: 'suggest_task_list',
        label: 'Suggest the group creates a task list before dividing up roles',
        description:
            'Propose a brief planning step to the group before anyone begins working.',
        energyDelta: -10,
        stressDelta: -5,
        focusDelta: 20,
        motivationDelta: 10,
        selfAdvocacyDelta: 10,
        timeMinutesDelta: 65,
        tag: 'initiated_structure',
        educationalFeedback:
            'Introducing structure to an unstructured situation is a coping strategy that benefits both Jordan and the group. Systematic thinkers often bring exactly this kind of value to collaborative work. The effort of speaking up in a group setting — particularly when social dynamics are unclear — is real. When it works, it aligns the environment more closely with Jordan\'s processing style.',
      ),
      GameChoice(
        id: 'disclose_needs_directly',
        label:
            'Tell the teacher directly that explicit structure and clear criteria make a significant difference',
        description:
            'Approach the teacher before the group starts and explain briefly what kind of environment helps — without necessarily naming a diagnosis.',
        energyDelta: -12,
        stressDelta: -8,
        selfAdvocacyDelta: 22,
        focusDelta: 12,
        motivationDelta: 8,
        timeMinutesDelta: 70,
        taskCompleted: 'Disclosed learning needs to teacher',
        tag: 'disclosed_needs_to_teacher',
        educationalFeedback:
            'Telling a teacher directly what kind of environment supports learning is a form of disclosure that does not require naming a diagnosis. "Clear criteria help me engage" is both accurate and complete. When teachers respond supportively, this kind of disclosure reduces the ongoing cost of navigating ambiguity. It is not always safe — but when it works, it tends to be more sustainable than masking.',
      ),
    ],
  ),

  // S3 — Lunch Table (replaces cafeteria_sensory; integrates Conversation note; consumes S2 tags)
  GameScenario(
    id: 'lunch_conversation',
    characterId: 'jordan',
    title: 'Lunch Table',
    timeLabel: '11:30 AM',
    sceneTone: 'lunch',
    sceneType: 'cafeteria',
    sceneArtwork: SceneArtworks.jordanCafeteriaConversation,
    sceneSemanticLabel:
        'Illustration of Jordan having a conversation in the school cafeteria',
    carryoverNotes: {
      'masked_confusing':
          'Masking confusion through the group project took something from the reservoir. Lunch lands on a system that isn\'t fully recovered.',
      'sought_clarity':
          'Having asked for clear criteria gave Jordan a small sense of agency. Lunch feels slightly more manageable than the morning suggested.',
      'initiated_structure':
          'Introducing structure to the group worked. Jordan arrives at lunch with something to show for the morning — and a bit more bandwidth because of it.',
      'disclosed_needs_to_teacher':
          'Telling the teacher what helps was an act of naming. Lunch lands differently afterward — something external now holds what Jordan was carrying.',
    },
    description:
        'Jordan is eating lunch with a group of friends. The cafeteria is loud — trays clatter, conversations overlap, and the fluorescent lights hum audibly. A friend is talking and expecting eye contact. Maintaining it feels like a task of its own.',
    narration:
        '"I can hear what they\'re saying. But keeping my eyes in the right place takes most of what I have left right now."',
    choices: [
      GameChoice(
        id: 'maintain_eye_contact',
        label: 'Maintain eye contact throughout the conversation',
        description:
            'Hold direct gaze as a way to appear engaged, even as it takes effort.',
        energyDelta: -18,
        stressDelta: 22,
        focusDelta: -12,
        motivationDelta: -5,
        timeMinutesDelta: 30,
        tag: 'masked_eye_contact',
        educationalFeedback:
            'Maintaining direct eye contact throughout a conversation is a social expectation many autistic people find effortful or uncomfortable. The effort required to sustain it can reduce the capacity left for actually processing what is being said. Appearing to listen can come at the cost of being able to listen.',
      ),
      GameChoice(
        id: 'look_forehead_nose',
        label: 'Look at the other person\'s forehead or nose instead',
        description:
            'Shift gaze slightly — it reads as attentive without requiring the full sensory effort of direct eye contact.',
        energyDelta: -6,
        stressDelta: -8,
        focusDelta: 5,
        timeMinutesDelta: 30,
        tag: 'redirect_gaze',
        educationalFeedback:
            'Looking at the forehead or nose is a widely used strategy that reduces the sensory intensity of direct eye contact while allowing a person to remain present in the conversation. It is a practical adaptation that does not require disclosing anything — it shifts the load to a more manageable level.',
      ),
      GameChoice(
        id: 'look_away_naturally',
        label: 'Look away when needed — glance back between thoughts',
        description:
            'Allow natural gaze breaks during the conversation rather than holding eye contact continuously.',
        energyDelta: -4,
        stressDelta: -15,
        focusDelta: 8,
        motivationDelta: 5,
        timeMinutesDelta: 30,
        tag: 'natural_gaze_breaks',
        educationalFeedback:
            'Allowing natural gaze breaks reduces the cognitive load of social interaction and leaves more capacity for actually engaging with the conversation. Gaze behavior varies widely across cultures and individuals. For many autistic people, intermittent eye contact is both more comfortable and more authentic than sustained direct gaze.',
      ),
      GameChoice(
        id: 'quiet_corner_lunch',
        label: 'Suggest moving to a quieter spot to eat and talk',
        description:
            'Mention to the group that the cafeteria is loud and ask if anyone wants to find a calmer place nearby.',
        energyDelta: 10,
        stressDelta: -18,
        focusDelta: 8,
        selfAdvocacyDelta: 12,
        timeMinutesDelta: 30,
        taskCompleted: 'Advocated for a quieter environment at lunch',
        tag: 'quiet_lunch_spot',
        educationalFeedback:
            'Suggesting a different environment is a form of low-stakes self-advocacy that also protects sensory wellbeing. A quieter setting can make conversation more accessible — for Jordan and potentially for others. Framing the request around the noise rather than a personal difficulty is often easier and more likely to be met positively.',
      ),
    ],
  ),

  // S4 — Classroom Overload (replaces ambiguous_feedback; integrates Classroom Sensory Overload note; consumes S3 tags)
  GameScenario(
    id: 'classroom_sensory_overload',
    characterId: 'jordan',
    title: 'Classroom Overload',
    timeLabel: '1:00 PM',
    sceneTone: 'class',
    sceneType: 'classroom',
    sceneArtwork: SceneArtworks.jordanClassroom,
    sceneSemanticLabel:
        'Illustration of Jordan in a classroom with sensory overload from lights and sounds',
    carryoverNotes: {
      'masked_eye_contact':
          'After masking through lunch, Jordan\'s sensory threshold is lower than usual. The overhead light flicker in this classroom feels sharper than it would otherwise.',
      'quiet_lunch_spot':
          'The quieter lunch helped. Jordan enters the afternoon period with slightly more available than the morning threatened.',
    },
    description:
        'The afternoon class has started. Overhead lights are bright and one tube flickers slightly. The HVAC hum has become impossible to ignore. A classmate nearby taps a pencil in an irregular rhythm. Jordan\'s sweater collar — manageable this morning — now feels scratchy against the skin.',
    narration:
        '"Every single thing in this room is asking for my attention at once. I\'m supposed to be listening to a lecture."',
    choices: [
      GameChoice(
        id: 'endure_sensory',
        label: 'Stay seated and push through the rest of class',
        description:
            'Keep working and try to ignore the sensory input. Do not draw attention.',
        energyDelta: -22,
        stressDelta: 28,
        focusDelta: -18,
        timeMinutesDelta: 50,
        tag: 'endured_class_sensory',
        educationalFeedback:
            'Staying in a high-stimulation environment without accommodation places the body in a prolonged stress response. The effort of suppressing sensory input competes with the cognitive effort of following the lesson. Over a full class period, this accumulates — leaving less capacity for everything that comes after.',
      ),
      GameChoice(
        id: 'use_earplugs',
        label: 'Take noise-reducing earplugs from a bag and put them in',
        description:
            'Quietly retrieve and insert earplugs to reduce audio input while staying in the room.',
        energyDelta: -5,
        stressDelta: -15,
        focusDelta: 12,
        timeMinutesDelta: 50,
        tag: 'earplugs_classroom',
        educationalFeedback:
            'Noise-reducing tools — earplugs, earbuds, or earmuffs — reduce auditory input to a more manageable level. Using them during class is a sensory accommodation, not a distraction. Many autistic people carry sensory tools as a routine part of managing their environment. Having the tool available shifts the choice from endure-or-leave to adjust.',
      ),
      GameChoice(
        id: 'request_sensory_break',
        label: 'Quietly ask the teacher for a brief sensory break',
        description:
            'Wait for a pause in the lesson and ask the teacher privately if a short break outside the classroom is possible.',
        energyDelta: 5,
        stressDelta: -22,
        focusDelta: 10,
        selfAdvocacyDelta: 22,
        timeMinutesDelta: 55,
        taskCompleted: 'Requested and received a sensory break',
        tag: 'sensory_break_granted',
        educationalFeedback:
            'Asking for a sensory break is a direct form of self-advocacy. It requires knowing what is needed, identifying the right moment, and being willing to ask. Not all teachers will respond the same way — when they do respond supportively, it models that asking is safe. When the environment is genuinely overloading, a brief break often allows better engagement afterward.',
      ),
    ],
  ),

  // S5 — Academic Accommodations: moved to shared_scenarios.dart as
  //       buildAccommodationsScenario(jordan). Wired in character_registry.dart
  //       at slot 5 (2:00 PM, endTimeLabel: 3:00 PM). Consumes S4 tags:
  //       endured_class_sensory · earplugs_classroom · sensory_break_granted.
];
