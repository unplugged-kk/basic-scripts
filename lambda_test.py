import json
import requests

# Replace the following variables with your own values
SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK/URL'
GITHUB_SECRET_TOKEN = 'YOUR_GITHUB_SECRET_TOKEN'
GITHUB_OWNER = 'YOUR_GITHUB_OWNER'
GITHUB_REPO = 'YOUR_GITHUB_REPO'
SLACK_CHANNEL = '#your-slack-channel'


def lambda_handler(event, context):
    # Get the GitHub event type and payload
    event_type = event['headers'].get('X-GitHub-Event')
    payload = json.loads(event['body'])
    # print(event_type)
    print(payload)

    # Handle the pull request event
    if event_type == 'pull_request':
        action = payload['action']
        if action == 'opened' or action == 'closed':
            pr_number = payload['number']
            pr_title = payload['pull_request']['title']
            pr_link = payload['pull_request']['html_url']
            pr_time = payload['pull_request']['created_at']

            # Construct the Slack message
            message = f"A new pull request has been {action} in {GITHUB_OWNER}/{GITHUB_REPO}:\n"
            message += f"> *Title:* {pr_title}\n"
            message += f"> *Time:* {pr_time}\n"
            message += f"> *Link:* {pr_link}"

            # Send the Slack message
            send_slack_message(message)

    return {'statusCode': 200, 'body': 'Success.'}


def send_slack_message(message):
    headers = {'Content-type': 'application/json'}
    payload = {'channel': SLACK_CHANNEL, 'text': message}

    response = requests.post(SLACK_WEBHOOK_URL, headers=headers, data=json.dumps(payload))

    if response.status_code != 200:
        raise ValueError('Request to Slack returned an error %s, the response is:\n%s' % (response.status_code, response.text))
