#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int run_command(const char *cmd, char *result, int max_len) {
  FILE *fp;
  fp = popen(cmd, "r");
  if (fp == NULL) {
    return -1;
  }
  if (fgets(result, max_len, fp) == NULL) {
    pclose(fp);
    return -1;
  }
  pclose(fp);
  // Remove trailing newline
  result[strcspn(result, "\n")] = 0;
  return 0;
}

int main() {
  char result[1024];

  // Check if inside a git repository
  if (run_command("git rev-parse --is-inside-work-tree 2>/dev/null", result,
                  sizeof(result)) != 0 ||
      strcmp(result, "true") != 0) {
    return 1;
  }

  // Get current branch name
  if (run_command("git rev-parse --abbrev-ref HEAD", result, sizeof(result)) !=
      0) {
    return 1;
  }
  char branch[256];
  strcpy(branch, result);

  // Get number of staged files
  run_command("git diff --cached --numstat | wc -l", result, sizeof(result));
  int staged = atoi(result);

  // Get number of conflicts
  run_command("git --no-pager diff --name-only --diff-filter=U | wc -l", result,
              sizeof(result));
  int conflicts = atoi(result);

  // Get number of modified files
  run_command("git --no-pager diff --name-only --diff-filter=M | wc -l", result,
              sizeof(result));
  int modified = atoi(result);

  // Get number of untracked files
  run_command("git ls-files --others --exclude-standard | wc -l", result,
              sizeof(result));
  int untracked = atoi(result);

  // Get number of deleted files
  run_command("git --no-pager diff --name-only --diff-filter=D | wc -l", result,
              sizeof(result));
  int deleted = atoi(result);

  // Get ahead and behind counts
  int ahead = 0, behind = 0;
  char remote_name[256], merge_name[256], remote_ref[256];

  // Check if on a specific branch or detached HEAD
  if (strcmp(branch, "HEAD") == 0) {
    run_command("git rev-parse --short HEAD", result, sizeof(result));
    snprintf(branch, sizeof(branch), ":%s", result);
  } else {
    run_command("git config branch.%s.remote", remote_name,
                sizeof(remote_name));
    run_command("git config branch.%s.merge", merge_name, sizeof(merge_name));

    if (strcmp(remote_name, ".") == 0) {
      snprintf(remote_ref, sizeof(remote_ref), "%s", merge_name);
    } else {
      snprintf(remote_ref, sizeof(remote_ref), "refs/remotes/%s/%s",
               remote_name, merge_name + 11);
    }

    snprintf(result, sizeof(result), "git rev-list --left-right %s...HEAD",
             remote_ref);
    FILE *revlist_fp = popen(result, "r");
    while (fgets(result, sizeof(result), revlist_fp) != NULL) {
      if (result[0] == '>') {
        ahead++;
      } else {
        behind++;
      }
    }
    pclose(revlist_fp);
  }

  printf("%s %d %d %d %d %d %d %d\n", branch, ahead, behind, staged, conflicts,
         modified, untracked, deleted);
  return 0;
}
