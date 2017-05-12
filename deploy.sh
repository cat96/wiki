# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
SHA=`git rev-parse --verify HEAD`
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in wiki_deploy_key.enc -out wiki_deploy_key -d
chmod 600 wiki_deploy_key
eval `ssh-agent -s`
ssh-add wiki_deploy_key

git config --global user.name "WikiBuildBot"
git config --global user.email "sukso96100@gmail.com"

export COMMITID = git rev-parse --short HEAD

git clone git@github.com:skhu-sw/wiki.git deploy && ls
cd deploy && ls
git checkout gh-pages
ls
rm -rf *
ls
cd ..
ls
npm install -g gitbook-cli
ls
gitbook install
gitbook build
ls
cp -a _book/. deploy/
cd deploy
ls
rm .travis.yml
ls
rm deploy.sh
ls
rm wiki_deploy_key.enc
ls
rm wiki_deploy_key
ls
git add --all
git commit -m "Updated Contents (via Travis CI) [${SHA}]"
git push origin gh-pages
