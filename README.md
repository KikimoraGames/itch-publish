# Itch.io - Publish GitHub Action

Helps you publish new releases to itch.io using butler.

## Inputs

| Name    | Required | Description                                                                                       |
|---------|----------|---------------------------------------------------------------------------------------------------|
| butlerAPIKey | Yes       | The secret API Key you can get by following these instructions: https://itch.io/docs/butler/login.html#running-butler-from-ci-builds-travis-ci-gitlab-ci-etc
| gameData | Yes | Directory or .zip file of the game data. Zip files are slower to upload.|
| itchUsername | Yes | username of the game owner. e.g. in `kikimora.itch.io/wizards-way-out` this would be `kikimora`|
| itchGameId | Yes | id of the game. e.g. in `kikimora.itch.io/wizards-way-out` this would be `wizards-way-out`
| buildChannel | Yes | Channel name of the game: https://itch.io/docs/butler/pushing.html#channel-names|
| buildNumber | No | Use to supply your own build version instead of using itch's versioning|
| buildNumberFile | No | use to supply your own build version instead of using itch's versioning. The file should contain a single line with the version or build number, in UTF-8 without BOM|

## Example usage

### Workflow configuration

```yaml
name: Deploy

on: push
env:
  ITCH_USERNAME: my-username
  ITCH_GAME_ID: my-game-id
jobs:
  deploy:
    name: Upload to Itch
    runs-on: ubuntu-latest
    strategy:
      fail-fast: true
      matrix:
        channel:
          - windows
          - webgl
    runs-on: ubuntu-latest
    name: Deploy - Itch.io ${{ matrix.template }}
    steps:
      - uses: actions/download-artifact@v2.0.8
        with:
          name: ${{ matrix.channel }}
          path: build/${{ matrix.channel }}
      - uses: KikimoraGames/itch-publish@v0.0.3
        with:
          butlerApiKey: ${{secrets.BUTLER_API_KEY}}
          gameData: ./build/${{ matrix.template }}
          itchUsername: ${{env.ITCH_USERNAME}}
          itchGameId: ${{ env.ITCH_GAME_ID }}
          buildChannel: ${{ matrix.channel }}
          buildNumber: ${{ needs.version.outputs.version_hash }}

```