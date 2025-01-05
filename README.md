# Binary-Safe
A simple binary safe using the DE-10 Lite Board, written (by me) in Verilog.

🚀 Features:
• 4-character PIN
• Binary input using 4 switches
• Easy navigation
• Failed attempts indicator
• Countdown timer after 4 failed attempts

Approach:
This feature-packed model of a safe provides secure access using
binary inputs while also moderately deterring attacks like brute-
forcing by tracking failed attempts and utilizing a countdown timer
to provide a cooldown between consecutive failed attempts.

🎛️ 1: Input
The user uses the 4 binary input switches to input a 4-bit binary
value to represent a decimal from 0-9, displayed in real-time on the
respective 7-segment LED (right to left), pressing the save button
to save the value and move on to the next character (to the left)
until all 4 characters are entered. The save button is very
intuitive, featuring a roll-over logic that allows the user to
easily navigate across the 4 characters if they wish to change any
of the values. The currently selected character also blinks at 1
second intervals as an intuitive visual indicator to the user.

✅ 2: Validation
Pressing the action button submits the 4-character PIN for
validation. If the PIN matches the default set passcode (1234), the
safe is unlocked and the word “OPEN” is displayed on the four 7-
segment LEDs. Pressing the action button locks the safe and returns
the user back to the PIN entry screen.
If the PIN is invalid, the input is cleared and 4 dashes are
displayed to the user signaling that the PIN is invalid,
additionally an invalid attempt is incremented and the number of
failed attempts is displayed using up to 4 LEDs on the Failed
attempts indicator.

❌ 3: Failed Attempts
After 4 failed attempts, PIN entry is disabled and a 9 second count-
down timer is displayed. Once the timer reaches 0, the PIN entry
screen is enabled again, and the invalid attempts are reset,
allowing the user to try again.

🫡 Vision: If I were to further improve on this project, I would add
the ability for the user to set their own preferred PIN once the
safe is initially unlocked. I would also build around the failed
attempts idea and exponentially increase the countdown time duration
every time the user further makes an invalid attempt.

Created by Adren Reuel
