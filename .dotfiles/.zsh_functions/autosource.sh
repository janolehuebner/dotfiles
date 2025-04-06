function autosource {
  local zsh_function_dirs zsh_function_dir

  # Check for required argument
  if (( $# == 0 )); then
    echo "autosource: basename of a file in ZSH_FUNC_PATH required"
    echo "autosource: usage: autosource basename [arguments]"
    return 1
  fi

  # Split ZSH_FUNC_PATH into an array
  IFS=':' read -rA zsh_function_dirs <<< "${ZSH_FUNC_PATH}"

  # Search each dir for a matching .zsh file
  for zsh_function_dir in "${zsh_function_dirs[@]}"; do
    if [[ -r "${zsh_function_dir}/${1}.zsh" ]]; then
      source "${zsh_function_dir}/${1}.zsh" "${@:2}"
      return
    fi
  done

  echo "autosource: no ${1} in (${ZSH_FUNC_PATH})"
  return 1
}

