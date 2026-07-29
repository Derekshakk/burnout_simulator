import '../models/game_choice.dart';
import '../models/game_scenario.dart';

const List<GameScenario> mayaScenarios = [
  GameScenario(
    id: 'maya_schedule_change',
    title: 'A Changed Plan',
    timeLabel: '8:30 AM',
    sceneTone: 'morning',
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
  GameScenario(
    id: 'maya_lunch_reset',
    title: 'The Between-Class Gap',
    timeLabel: '11:00 AM',
    sceneTone: 'class',
    carryoverNotes: {
      'maya_split_attention':
          'After an hour of switching attention, even choosing lunch feels like another task. Maya\'s body is asking for fewer inputs.',
      'maya_protected_focus':
          'Protecting one channel during studio left Maya with enough bandwidth to notice what would actually help next.',
    },
    description:
        'There are 40 minutes before the next class. The student center is busy and a friend invites Maya to eat there. Maya also needs food, a bathroom break, and a moment away from screens before an afternoon critique.',
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
            'Connection can be meaningful and still be costly in a high-demand environment. The tradeoff is not a moral one: choosing social time may be right sometimes, while choosing regulation may be essential at other times.',
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
            'A low-sensory lunch is active recovery. Food, quiet, movement, and sensory tools can restore capacity enough to make the afternoon more possible. Solitude in this context is regulation, not rejection.',
      ),
      GameChoice(
        id: 'maya_invite_one_friend',
        label: 'Invite one friend to eat in a quieter spot',
        description:
            'Suggest a bench outside the student center so Maya can keep connection while reducing sensory demand.',
        energyDelta: 7,
        stressDelta: -10,
        motivationDelta: 8,
        lifeSatisfactionDelta: 8,
        selfAdvocacyDelta: 10,
        timeMinutesDelta: 40,
        tag: 'maya_adapted_connection',
        educationalFeedback:
            'Adapting the setting can make connection more sustainable. Naming a different plan gives friends a concrete way to show care, and it avoids treating Maya\'s needs and relationships as competing priorities.',
      ),
    ],
  ),
  GameScenario(
    id: 'maya_critique',
    title: 'Project Critique',
    timeLabel: '1:00 PM',
    sceneTone: 'class',
    carryoverNotes: {
      'maya_socially_drained':
          'The student center took more energy than Maya expected. The thought of speaking in front of the class now feels physically louder.',
      'maya_quiet_reset':
          'The quieter break did not solve every demand, but Maya arrives with more room to think and respond.',
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
    ],
  ),
  GameScenario(
    id: 'maya_evening',
    title: 'Closing the Day',
    timeLabel: '2:30 PM',
    endTimeLabel: '3:00 PM',
    sceneTone: 'evening',
    carryoverNotes: {
      'maya_masked_critique':
          'The effort of responding on demand followed Maya into the afternoon. The to-do list now feels like a wall rather than a set of options.',
      'maya_processing_time':
          'Giving the ideas time to arrive helped Maya leave critique with less of the usual replaying and self-doubt.',
    },
    description:
        'The day is ending, but a project task and two emails remain. Maya also wants to spend time refining an exhibit concept that is genuinely exciting. The work matters, and so does recovering enough to return tomorrow.',
    narration:
        '"I need a plan that leaves something of me for tomorrow, not one that proves I can ignore tonight."',
    choices: [
      GameChoice(
        id: 'maya_all_nighter_plan',
        label: 'Commit to finishing every remaining task tonight',
        description:
            'Make a long list and plan to keep working until everything is done.',
        energyDelta: -25,
        stressDelta: 22,
        motivationDelta: -12,
        timeMinutesDelta: 30,
        educationalFeedback:
            'Trying to solve every unfinished task with more effort can turn urgency into burnout. When capacity is low, a longer plan may create more pressure than progress. Rest is part of completing work sustainably.',
      ),
      GameChoice(
        id: 'maya_choose_one_next_step',
        label: 'Choose one small task, schedule the rest, then decompress',
        description:
            'Send one important email, put the project on tomorrow\'s calendar, and transition into a preferred low-demand activity.',
        energyDelta: 8,
        stressDelta: -15,
        focusDelta: 5,
        motivationDelta: 10,
        lifeSatisfactionDelta: 8,
        taskCompleted: 'Made a sustainable end-of-day plan',
        tag: 'maya_sustainable_close',
        educationalFeedback:
            'A small, visible next step reduces the fear of forgetting without demanding that Maya finish a whole second day of work. Planning recovery alongside responsibilities supports consistency better than relying on crisis-level effort.',
      ),
      GameChoice(
        id: 'maya_body_double_start',
        label: 'Ask a friend for a short body-doubling session',
        description:
            'Work quietly alongside someone for 20 minutes to start the first task, then reassess capacity.',
        energyDelta: 2,
        stressDelta: -10,
        focusDelta: 12,
        selfAdvocacyDelta: 10,
        motivationDelta: 8,
        timeMinutesDelta: 30,
        taskCompleted: 'Used body-doubling to start a task',
        tag: 'maya_body_doubling',
        educationalFeedback:
            'Body-doubling — doing a task alongside another person — can make starting and staying with a task more accessible for many people with ADHD. It is a collaborative support, not dependence, and it can coexist with autistic needs for low-pressure communication.',
      ),
    ],
  ),
];
