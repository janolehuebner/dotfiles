# Function to extract the video ID from a YouTube URL
video_id() {
    local url=$1
    local video_id=""

    # Extract the video ID using Zsh pattern matching
    if [[ $url =~ (v=|\/)([0-9A-Za-z_-]{11}).* ]]; then
        video_id=${match[2]}
    else
        echo "Invalid YouTube URL"
        return 1
    fi

    echo $video_id
}

# Function to initiate the download process
ytr () {
    if [[ $# -eq 0 ]]; then
        echo "Usage: ytr <Youtube_URL>"
        return 1
    fi

    local youtube_url=$1
    local youtube_id=$(video_id "$youtube_url")

    if [[ $? -ne 0 ]]; then
        echo "Failed to extract video ID"
        return 1
    fi

    local token="$(pass $TUBE_TOKEN_NAME_IN_STORE)"
    local json_data=$(jq -n --arg youtube_id "$youtube_id" '{
        data: [
            {
                youtube_id: $youtube_id,
                status: "pending",
            }
        ],
        autostart: true
    }')

    curl -X POST -H "Content-Type: application/json" -H "Authorization: Token $token" -d "$json_data" http://$NAS_IP:4601/api/download/
}


#############
####function to check missed shorts

# Add this to your ~/.bashrc or ~/.bash_profile

yts() {
    # Check if the user provided a channel name
    if [ -z "$1" ]; then
        echo "Error: No channel name provided."
        echo "Usage: yts <channel_name>"
        return 1
    fi

    # Set the token and URL
    local token="$(pass $TUBE_TOKEN_NAME_IN_STORE)"

    # Initialize an empty array to store video data
    local video_data="[]"

    # Get the video IDs from yt-dlp and loop through each one
    while read -r youtube_id; do
        # Add each video ID to the array of data (accumulating in $video_data)
        video_data=$(echo "$video_data" | jq --arg youtube_id "$youtube_id" '. + [{youtube_id: $youtube_id, status: "pending"}]')
    done < <(yt-dlp "https://www.youtube.com/@$1/shorts" --flat-playlist --print "%(id)s")

    # Check if video_data is still an empty array (meaning no videos were found)
    if [[ "$video_data" == "[]" ]]; then
        echo "No videos found for channel $1."
        return 1
    fi

    # Create the final JSON payload with the accumulated video data
    json_data=$(jq -n --argjson video_data "$video_data" '{
        data: $video_data,
        autostart: true
    }')

    curl -X POST -H "Content-Type: application/json" -H "Authorization: Token $token" -d "$json_data" http://$NAS_IP:4601/api/download/
}



###### check all
#

check_shorts() {
    # List of channels to check (you can hardcode them or pass them as arguments)
    channels=(
        "DarkBlondii"
        "littlesiha"
        "lenaindica"
    )

    # Loop through each channel and call yts
    for channel in "${channels[@]}"; do
        echo "Checking shorts for channel: $channel"
        yts "$channel"
    done
}

#
