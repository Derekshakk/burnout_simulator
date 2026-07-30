import '../models/game_choice.dart';
import '../models/game_scenario.dart';

const List<GameScenario> mayaScenarios = [
  GameScenario(
    id: 'maya_schedule_change',
    title: 'A Changed Plan',
    timeLabel: '8:30 AM',
    sceneTone: 'morning',
    sceneImagePath: 'assets/stories/time_Awareness.jpg',
    sceneSemanticLabel:
        'Illustration representing an unexpected schedule change and time planning',
    description:
        'Maya opens the course portal before class and finds that today\'s studio session has moved online. The announcement was posted late last night, and the video link is buried in a long message. Maya had planned the morning around being on campus.',
    narration:
        '"My whole start-of-day sequence is wrong. I can do this, but I need to know exactly what happens next."',
    choices: [
      GameChoice(
        id: 'maya_search_while_rushing',
        label: 'Rush through the announcement while trying to join immediately',
        description:
            'Skim the message, open several tabs, and try to catch up without pausing to reorient.',
        energyDelta: -15,
        focusDelta: -12,
        stressDelta: 20,
        timeMinutesDelta: 25,
        tag: 'maya_rushed_change',
        educationalFeedback:
            'An unexpected change can use up executive-function capacity before the task even begins. Rushing to compensate may save a few minutes while increasing confusion and stress. Needing time to reorient is a reasonable access need, not a lack of effort.',
      ),
      GameChoice(
        id: 'maya_make_next_steps',
        label: 'Write down the link, start time, and first three next steps',
        description:
            'Pause briefly, find the essential details, and make a small external plan before joining.',
        energyDelta: -4,
        focusDelta: 12,
        stressDelta: -12,
        selfAdvocacyDelta: 5,
        timeMinutesDelta: 20,
        taskCompleted: 'Created a plan for the schedule change',
        tag: 'maya_externalized_plan',
        educationalFeedback:
            'Externalizing the plan reduces the load of holding several new details in working memory. A short list is not over-preparing; it is an effective support for task switching, time awareness, and uncertainty.',
      ),
      GameChoice(
        id: 'maya_message_instructor',
        label: 'Message the instructor to confirm the essential details',
        description:
            'Ask for the link and whether anything needs to be prepared before joining.',
        energyDelta: -6,
        stressDelta: -8,
        focusDelta: 6,
        selfAdvocacyDelta: 15,
        timeMinutesDelta: 20,
        taskCompleted: 'Clarified the changed class plan',
        tag: 'maya_clarified_change',
        educationalFeedback:
            'Asking for concrete information is self-advocacy. Clear communication from instructors benefits many students, especially when a routine changes at short notice. The social effort of asking is real, even when the question seems simple.',
      ),
    ],
  ),
  GameScenario(
    id: 'maya_online_class',
    title: 'Too Many Signals',
    timeLabel: '9:00 AM',
    sceneTone: 'class',
    sceneImagePath: 'assets/stories/bedroom_background.jpg',
    sceneSemanticLabel:
        'Illustration of a home workspace during an online class session',
    carryoverNotes: {
      'maya_rushed_change':
          'Maya joins with several tabs still open and the sense of being behind. Each new notification feels more urgent than it is.',
    },
    description:
        'The online studio begins. The instructor talks over slides, chat messages arrive quickly, and a group partner sends three direct messages about a separate assignment. Maya is interested in the topic but cannot tell which signal deserves attention first.',
    narration:
        '"I want to contribute. I just need the volume turned down enough to find one thread."',
    choices: [
      GameChoice(
        id: 'maya_follow_everything',
        label: 'Try to follow the slides, chat, and messages all at once',
        description:
            'Keep every channel open and respond as each new item appears.',
        energyDelta: -18,
        focusDelta: -18,
        stressDelta: 22,
        timeMinutesDelta: 60,
        tag: 'maya_split_attention',
        educationalFeedback:
            'Multiple simultaneous inputs can overwhelm attention regulation and sensory processing. This is not a matter of trying harder: prioritizing channels is an environmental and executive-function support, not a shortcut.',
      ),
      GameChoice(
        id: 'maya_silence_nonessential',
        label: 'Mute nonessential notifications and focus on the live class',
        description:
            'Turn off message alerts for the hour and write down the partner\'s task to revisit after class.',
        energyDelta: -5,
        focusDelta: 15,
        stressDelta: -10,
        timeMinutesDelta: 60,
        taskCompleted: 'Protected focus during studio',
        tag: 'maya_protected_focus',
        educationalFeedback:
            'Reducing competing inputs creates a workable attention environment. Capturing the other task in a note preserves it without asking Maya\'s brain to keep switching back to it. This is a practical boundary, not avoidance.',
      ),
      GameChoice(
        id: 'maya_request_notes',
        label: 'Ask whether slides or a recording will be available afterward',
        description:
            'Use the chat to ask for an accessible way to revisit the material.',
        energyDelta: -5,
        stressDelta: -8,
        selfAdvocacyDelta: 15,
        focusDelta: 8,
        timeMinutesDelta: 60,
        taskCompleted: 'Requested accessible class materials',
        tag: 'maya_requested_materials',
        educationalFeedback:
            'Recordings and slides give people more than one chance to process information. Requesting them supports learning without assuming that everyone can absorb speech, visuals, chat, and social cues at the same pace.',
      ),
    ],
  ),

  // S3 — Between-Class Gap: moved to shared_scenarios.dart as
  //       buildLunchBreakScenario(maya). Wired in character_registry.dart at
  //       slot 3 (11:00 AM). Consumes S2 tags: maya_split_attention ·
  //       maya_protected_focus. Sets: maya_socially_drained · maya_quiet_reset.
  GameScenario(
    id: 'maya_critique',
    title: 'Project Critique',
    timeLabel: '1:00 PM',
    sceneTone: 'class',
    sceneImagePath: 'assets/stories/maya_disclosing_to_teacher.jpg',
    sceneSemanticLabel:
        'Illustration of Maya speaking with an instructor during a project critique',
    carryoverNotes: {
      'maya_socially_drained':
          'The student center took more energy than Maya expected. The thought of speaking in front of the class now feels physically louder.',
      'maya_quiet_reset':
          'The quieter break did not solve every demand, but Maya arrives with more room to think and respond.',
      'maya_adapted_connection':
          'Choosing a quieter way to connect protected Maya\'s energy without giving up the relationship. The critique still asks a lot, but there is more room to process it.',
    },
    description:
        'In critique, each student must share a project draft and receive rapid verbal feedback. Maya has strong ideas but needs a moment to process comments before responding. The instructor says, “Jump in whenever you\'re ready.”',
    narration:
        '"I have thoughts, but they are not arriving in a sentence yet. If I wait, will they think I have nothing?"',
    choices: [
      GameChoice(
        id: 'maya_force_immediate_response',
        label: 'Respond to every comment immediately',
        description:
            'Push through the processing delay and answer before each speaker moves on.',
        energyDelta: -18,
        stressDelta: 20,
        focusDelta: -10,
        motivationDelta: -8,
        timeMinutesDelta: 60,
        tag: 'maya_masked_critique',
        educationalFeedback:
            'Rapid-response formats can privilege speed over thoughtfulness. Masking a processing delay uses energy and can make it harder to engage with the feedback itself. Needing pause time does not mean the ideas are absent.',
      ),
      GameChoice(
        id: 'maya_take_notes_then_share',
        label: 'Take notes and ask to add a response after a short pause',
        description:
            'Write down feedback, then tell the instructor Maya will share a considered response in a few minutes or after class.',
        energyDelta: -6,
        stressDelta: -8,
        focusDelta: 14,
        selfAdvocacyDelta: 15,
        timeMinutesDelta: 60,
        taskCompleted: 'Requested processing time in critique',
        tag: 'maya_processing_time',
        educationalFeedback:
            'Requesting processing time supports more accurate and meaningful participation. It is a reasonable adjustment to a format that moves faster than some people can comfortably process, not a request for lower expectations.',
      ),
      GameChoice(
        id: 'maya_share_visual_notes',
        label: 'Share a visual outline of the project instead of improvising',
        description:
            'Use prepared sketches and notes to guide the feedback conversation.',
        energyDelta: -4,
        stressDelta: -5,
        focusDelta: 12,
        motivationDelta: 10,
        selfAdvocacyDelta: 8,
        timeMinutesDelta: 60,
        taskCompleted: 'Used a visual outline in critique',
        tag: 'maya_visual_strength',
        educationalFeedback:
            'Offering a visual or written route into discussion can align the task with a person\'s strengths. Flexible participation formats make room for different communication styles while preserving the substance of the critique.',
      ),
      GameChoice(
        id: 'maya_disclose_processing_needs',
        label:
            'Tell the instructor after the critique that real-time response formats are harder — and ask about alternatives',
        description:
            'After the session, approach the instructor and explain that processing-heavy real-time formats present more difficulty, and ask whether written follow-up responses are an option.',
        energyDelta: -10,
        stressDelta: -8,
        selfAdvocacyDelta: 25,
        focusDelta: 8,
        motivationDelta: 5,
        timeMinutesDelta: 60,
        taskCompleted: 'Disclosed processing needs to instructor',
        tag: 'maya_disclosed_to_instructor',
        educationalFeedback:
            'Telling an instructor what processing conditions work better is a disclosure — whether or not a diagnosis is mentioned. "Real-time verbal responses are harder for me than written ones" is both accurate and actionable. Instructors who respond by offering alternatives model that the course format is not fixed. This kind of disclosure can change the terms of participation without requiring formal documentation to be in place first.',
      ),
    ],
  ),
  // S5 — Academic Accommodations: moved to shared_scenarios.dart as
  //       buildAccommodationsScenario(maya). Wired in character_registry.dart
  //       at slot 5 (2:30 PM, endTimeLabel: 3:00 PM). Consumes S4 tags:
  //       maya_masked_critique · maya_processing_time · maya_visual_strength.
];
