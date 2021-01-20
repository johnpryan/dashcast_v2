# dashcast_app

## Deployment

Build the app:

```
flutter build web
```

```
firebase deploy --only hosting
```

## Firebase hosting setup

- [Get started with Fireabase Hosting](https://firebase.google.com/docs/hosting/quickstart)

```
firebase init hosting
```

Follow the prompts:

```
What do you want to use as your public directory? build/web
Configure as a single-page app (rewrite all urls to /index.html)? Yes
File build/web/index.html already exists. Overwrite? No
```

This creates a firebase.json file that you can commit to source control.

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

To deploy, run the following command:
